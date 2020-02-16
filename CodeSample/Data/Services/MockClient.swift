//
//  MockClient.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/8/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

/// `MockClient` is responsible for providing mock data when developing or running tests.
/// The core of this client is empty and all of its mock data comes from its extensions. See `MockClient+FlickrProvider`.
struct MockClient {
	/// The default `MockClient`
	static var shared: MockClient {
		return MockClient()
	}

	let decoder = JSONDecoder()
}
