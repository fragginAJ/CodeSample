//
//  GeolocationManager.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/// `GeolocationManager` can be used to request location permissions and is responsible for reporting changes in
/// permission or location.
final class GeolocationManager: NSObject {
	// MARK: properties
	static let shared: GeolocationManager = GeolocationManager()

	private let locationManager = CLLocationManager()
	private let geocoder = CLGeocoder()

	weak var delegate: GeolocationManagerDelegate? = nil

	// MARK: initializers
	override init() {
		super.init()

		locationManager.delegate = self
	}

	/// The device's current location. This will always be nil if the user has not been prompted for and given permission.
	private(set) var currentLocation: CLLocation? {
		didSet {
			guard let location = currentLocation else { return }

			delegate?.locationDidUpdate(location)
		}
	}

	// MARK: internal functions
	/// Requests location services authorization and starts monitoring.
	func configureLocationServices() {
		guard CLLocationManager.authorizationStatus() != .notDetermined else {
			locationManager.requestWhenInUseAuthorization()
			return
		}

		locationManager.stopUpdatingLocation()

		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
			locationManager.distanceFilter = 500
			locationManager.startUpdatingLocation()
		}
		else {
			redirectToSettingsAppIfNeeded()
		}
	}

	/// Call this function when you no longer need location service updates.
	func stopLocationService() {
		locationManager.stopUpdatingLocation()
	}

	/// Converts a `CLLocation` into a human readable location name. Attempts to report back locality (city) name but will
	/// fall back on administrative area (state) or country code if necessary. Defaults to "Nowhere".
	///
	/// - Parameters:
	///   - location: The location to determine the name of
	///   - completion: Executed when reverse geocoding has succeeded or failed to find a location name
	func reverseGeocodeLocationName(from location: CLLocation,
									completion: @escaping (_ locationName: String?, _ error: Error?) -> Void ) {
		geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
			guard let placemark = placemarks?.first,
				error == nil else {
				completion(nil, error)
				return
			}

			if let locality = placemark.locality { completion(locality, nil) }
			else if let adminArea = placemark.administrativeArea { completion(adminArea, nil) }
			else if let country = placemark.country { completion(country, nil) }
			else { completion("Nowhere", nil) }
		}
	}

	// MARK: private functions
	private func redirectToSettingsAppIfNeeded() {
		// One of two scenarios has occurred. Either the phone has diabled Location
		// Services or the user has disabled the app's access to the Location Services.

		if CLLocationManager.authorizationStatus() == .denied {
			// If location services have been turned off for the entire phone,
			// 'requestWhenInUseAuthorization' will pop a alert which will then take a user
			// to Location Services within the settings Application.
			// Otherwise it will do nothing.
			locationManager.requestWhenInUseAuthorization()
		}

		// If Location services for the app has been has been disabled manually.
		// Application should push to Location Services within settings application.
		if CLLocationManager.authorizationStatus() == .denied {
			// If root ViewController is not an AlertVC, continue.
			guard let rootVC = UIApplication.shared.keyWindow?.rootViewController,
				!rootVC.isKind(of:UIAlertController.self) else { return }

			let alertVC = UIAlertController(title: "Location services are disabled",
											message: "Please enable and provide access to location services",
											preferredStyle: .alert)

			let settingsAction = UIAlertAction(title: "Settings",
											   style: .default,
											   handler: { (action) in self.openLocationServicesWithinSettingsApp() })

			let cancelAction = UIAlertAction(title: "Cancel",
											 style: .default,
											 handler: { (action) in alertVC.dismiss(animated: true, completion: nil) })

			alertVC.addAction(settingsAction)
			alertVC.addAction(cancelAction)
			rootVC.present(alertVC, animated: true, completion: nil)
		}
	}

	private func openLocationServicesWithinSettingsApp() {
		guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}

// MARK: - `CLLocationManagerDelegate` -
extension GeolocationManager: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = locations.last
	}

	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		guard status != .notDetermined else { return }

		let enabled = status == .authorizedAlways || status == .authorizedWhenInUse
		if enabled {
			configureLocationServices()
			delegate?.locationPermissionsDidUpdate?(approved: enabled)
		}
	}
}
