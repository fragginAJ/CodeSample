//
//  GeolocationManagerTests.swift
//  CodeSampleTests
//
//  Created by AJ Fragoso on 2/4/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import XCTest
import CoreLocation
@testable import CodeSample

class GeolocationManagerTests: XCTestCase {
	func testReverseGeocodeCupertino() {
		let expectation = XCTestExpectation(description: "Expecting reverse geocoding result")
		let cupertino = CLLocation(latitude: 37.331892, longitude: -122.030208)
		GeolocationManager.shared.reverseGeocodeLocationName(from: cupertino) { (locationName, error) in
			guard error == nil else {
				XCTFail("Failed to reverse geocode: " + error.debugDescription)
				return
			}

			guard let locationName = locationName,
				locationName == "Cupertino" else {
					XCTFail("Failed to reverse geocode")
					return
			}

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 5.0)
	}

	func testReverseGeocodeNowhere() {
		let expectation = XCTestExpectation(description: "Expecting reverse geocoding result")
		let nowhere = CLLocation(latitude: 0, longitude: 0)
		GeolocationManager.shared.reverseGeocodeLocationName(from: nowhere) { (locationName, error) in
			guard error == nil else {
				XCTFail("Failed to reverse geocode: " + error.debugDescription)
				return
			}

			guard let locationName = locationName,
				locationName == "Nowhere" else {
					XCTFail("Failed to reverse geocode")
					return
			}

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 5.0)
	}
}
