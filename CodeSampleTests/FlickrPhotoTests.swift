//
//  FlickrPhotoTests.swift
//  CodeSampleTests
//
//  Created by AJ Fragoso on 2/8/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import XCTest
@testable import CodeSample

class FlickrPhotoTests: XCTestCase {

	/// Tests the mapping of mock data into `FlickrPhoto` objects
	func testMockJSONDecoding() {
		let expectation = XCTestExpectation(description: "Expecting mock response")

		MockClient.shared.trendingPhotos { (photos, error) in
			XCTAssert(photos.count == 22)

			let firstPhoto = photos.first!
			XCTAssert(firstPhoto.id == "25408240053")
			XCTAssert(firstPhoto.owner == "113500642@N04")
			XCTAssert(firstPhoto.secret == "588cfe81c0")
			XCTAssert(firstPhoto.server == "1529")
			XCTAssert(firstPhoto.farm == 2)
			XCTAssert(firstPhoto.title == "Portrait of Elisa")
			XCTAssert(firstPhoto.isPublic == true)
			XCTAssert(firstPhoto.isFriend == false)
			XCTAssert(firstPhoto.isFamily == false)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 5.0)
	}

	/// Tests connection to Flickr API
	func testFlickrTrendingPhotos() {
		let expectation = XCTestExpectation(description: "Expecting trending photos response from Flickr")

		NetworkClient.shared.trendingPhotos { (photos, error) in
			guard error == nil, photos.count > 0 else {
				XCTFail("Encountered an error or empty response from Flickr trending photos request: \(error.debugDescription)")
				return
			}
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10.0)
	}
    
    func testFlickrSearch() {
        let expectation = XCTestExpectation(description: "Expecting search response from Flickr")
        
        let timesSquareLatitude = 40.7580
        let timesSquareLongitude = 73.9855
        
        NetworkClient.shared.searchPhotos(latitude: timesSquareLatitude,
                                          longitude: timesSquareLongitude) { (photos, error) in
                                            guard error == nil, photos.count > 0 else {
                                                XCTFail("Encountered an error or empty response from Flickr search request: \(error.debugDescription)")
                                                return
                                            }
                                            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
