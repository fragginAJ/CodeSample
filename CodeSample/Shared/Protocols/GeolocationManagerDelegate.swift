//
//  GeolocationManagerDelegate.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/4/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import CoreLocation

/// `GeolocationManagerDelegate` will receive updates from the `GeolocationManager` regarding location services permissions,
/// and location updates.
@objc protocol GeolocationManagerDelegate {
	/// Fires when an update in location has been reported
	///
	/// - Parameter location: The newest location
	@objc optional func locationDidUpdate(_ location: CLLocation)

	/// Fires when a change in location services permission has been detected
	///
	/// - Parameter approved: Whether or not location is enabled for this app
	@objc optional func locationPermissionsDidUpdate(approved: Bool)
}
