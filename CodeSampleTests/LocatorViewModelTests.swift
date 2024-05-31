//
//  LocatorViewModelTests.swift
//  CodeSampleTests
//
//  Created by AJ Fragoso on 5/30/24.
//  Copyright © 2024 AJ Fragoso. All rights reserved.
//

import XCTest
@testable import CodeSample

final class LocatorViewModelTests: XCTestCase {

    func testRequestPhotos() {
        let expectation = XCTestExpectation(description: "Expecting updated photos")
        let viewModel = LocatorViewModel(flickrProvider: MockClient.shared)
        viewModel.requestPhotos { _ in
            guard viewModel.photos.count > 0 else {
                XCTFail("LocatorViewModel")
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
