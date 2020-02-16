//
//  FlickrProvider.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/5/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

/// `FlickrProvider` outlines the functionality available when interacting with the Flickr API
protocol FlickrProvider {
	/// Search for photos within 5 km of the supplied coordinates
	///
	/// - Parameters:
	///   - latitude: Latitude of coordinates to search
	///   - longitude: Longitude of coordinates to search
	///   - completionHandler: Executes upon completion of request
	func searchPhotos(latitude: Double, longitude: Double, completionHandler: @escaping ([FlickrPhoto], Error?) -> Void)

	/// Photos from the Flickr editorial gallery
	///
	/// - Parameter completionHandler: Executes upon completion of request
	func trendingPhotos(completionHandler: @escaping ([FlickrPhoto], Error?) -> Void)
}
