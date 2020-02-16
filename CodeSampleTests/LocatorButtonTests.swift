//
//  LocatorButtonTests.swift
//  CodeSampleTests
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import XCTest
@testable import CodeSample

class LocatorButtonTests: XCTestCase {

	var button = LocatorButton()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		button = LocatorButton()
		button.layoutIfNeeded()
    }
    
    func testInit() {
        XCTAssertNotNil(button)
    }
    
	func testUpdateLocationName() {
		let initialWidth = button.frame.width
		button.updateLocationName("Brooklyn, NY")

		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			XCTAssert(self.button.frame.width > initialWidth, "Button width should grow with location update")
		}
	}
    
}
