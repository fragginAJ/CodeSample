//
//  FlickrConstants.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/8/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

/// `FlickrConstants` contains constants used in communication with the Flickr API
class FlickrConstants {
	static let shared: FlickrConstants = FlickrConstants()

	var apiKey: String? = nil

	enum ParameterKeys: String {
		case apiKey = "api_key"
		case apiSignature = "api_sig"
		case format = "format"
		case galleryID = "gallery_id"
		case latitude = "lat"
		case longitude = "lon"
		case method = "method"
		case noJSONCallback = "nojsoncallback"
		case perPage = "per_page"
	}
}
