//
//  LocatorViewModel.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/10/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import CoreLocation

/// `LocatorViewModel` is the view model of `LocatorViewController`, used to manage networking and `CoreLocation`
/// flows before ultimately notifying the controller of the results.
class LocatorViewModel {
	var controller: LocatorViewController?
	private var geolocating = false

	func geolocate() {
		GeolocationManager.shared.delegate = self
		geolocating = true

		if let currentLocation = GeolocationManager.shared.currentLocation {
			locationDidUpdate(currentLocation)
		} else {
			GeolocationManager.shared.setupLocationServices()
		}
	}

	func requestPhotos() {
		if let location = GeolocationManager.shared.currentLocation {
			NetworkClient.shared.searchPhotos(latitude: location.coordinate.latitude,
											  longitude: location.coordinate.longitude,
											  completionHandler: { [weak self] (photos, error) in
												if let error = error {
													self?.controller?.showAlert(title: "Uh oh. Something's wrong",
																					 message: error.localizedDescription,
																					 acknowledgement: "OK")
												} else {
													self?.controller?.didUpdatePhotos(photos)
												}
			})
		} else {
			NetworkClient.shared.trendingPhotos { [weak self] (photos, error) in
				if let error = error {
					self?.controller?.showAlert(title: "Uh oh. Something's wrong",
													 message: error.localizedDescription,
													 acknowledgement: "OK")
				} else {
					self?.controller?.didUpdatePhotos(photos)
				}
			}
		}
	}
}

// MARK: - `GeolocationManagerDelegate` -
extension LocatorViewModel: GeolocationManagerDelegate {
	func locationDidUpdate(_ location: CLLocation) {
		guard geolocating else { return }

		GeolocationManager.shared.reverseGeocodeLocationName(from: location) { [unowned self] (locationName, error) in
			guard error == nil,
				let locationName = locationName else {
					self.controller?.showAlert(title: "Uh oh. Something's wrong",
													message: error.debugDescription,
													acknowledgement: "OK")
					return
			}

			self.controller?.updateLocationName(locationName)
			self.geolocating = false
			self.requestPhotos()
		}
	}
}
