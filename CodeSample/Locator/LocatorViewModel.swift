//
//  LocatorViewModel.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/10/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/// `LocatorViewModelDelegate` alerts the delegated view controller of location changes.
protocol LocatorViewModelDelegate: UIViewController {
    func foundNewLocationName()
    func failedToFindLocation(_ error: Error)
}

/// `LocatorViewModel` is the view model of `LocatorViewController`, used to manage networking and `CoreLocation`
/// flows before ultimately notifying the controller of the results.
final class LocatorViewModel {
    
    // MARK: internal properties
    var photos: [FlickrPhoto] = []
    var locationName: String = ""
    weak var delegate: LocatorViewModelDelegate?
    let flickrProvider: FlickrProvider
    
    // MARK: private properties
	private var isGeolocating = false

    // MARK: initializers
    init(delegate: LocatorViewModelDelegate? = nil, flickrProvider: FlickrProvider = NetworkClient.shared) {
        self.delegate = delegate
        self.flickrProvider = flickrProvider
    }
    
    // MARK: internal functions
	func geolocate() {
		GeolocationManager.shared.delegate = self
		isGeolocating = true

		if let currentLocation = GeolocationManager.shared.currentLocation {
			locationDidUpdate(currentLocation)
		} else {
			GeolocationManager.shared.configureLocationServices()
		}
	}

    func requestPhotos(completion: @escaping (Error?) -> Void) {
        if let location = GeolocationManager.shared.currentLocation {
            flickrProvider.searchPhotos(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            ) { [weak self] (photos, error) in
                guard let self else { return }
                self.photos = photos
                completion(error)
            }
        } else {
            flickrProvider.trendingPhotos { [weak self] (photos, error) in
                guard let self else { return }
                self.photos = photos
                completion(error)
            }
        }
	}
}

// MARK: - `GeolocationManagerDelegate` -
extension LocatorViewModel: GeolocationManagerDelegate {
	func locationDidUpdate(_ location: CLLocation) {
		guard isGeolocating else { return }

		GeolocationManager.shared.reverseGeocodeLocationName(
            from: location
        ) { [weak self] (locationName, error) in
            guard let self else { return }

            self.isGeolocating = false
            
            if let error {
                delegate?.failedToFindLocation(error)
            } else if let locationName {
                self.locationName = locationName
                delegate?.foundNewLocationName()
            }
		}
	}
}
