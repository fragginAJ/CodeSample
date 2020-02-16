//
//  NetworkClient+Flickr.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/6/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

// MARK: - `FlickrProvider`
extension NetworkClient: FlickrProvider {
	func trendingPhotos(completionHandler: @escaping ([FlickrPhoto], Error?) -> Void) {
		request(endpoint: FlickrEndpoint.trendingPhotos) { (photoResponse: FlickrPhotoResponse?, error: Error?) in
			guard let photoResponse = photoResponse, error == nil else {
				completionHandler([], error)
				return
			}
			completionHandler(photoResponse.photoSet.photos, nil)
		}
	}

	func searchPhotos(latitude: Double, longitude: Double, completionHandler: @escaping ([FlickrPhoto], Error?) -> Void) {
		request(endpoint: FlickrEndpoint.searchPhotosByLocation(latitude: latitude, longitude: longitude))
		{ (photoResponse: FlickrPhotoResponse?, error: Error?) in
			guard let photoResponse = photoResponse, error == nil else {
				completionHandler([], error)
				return
			}
			completionHandler(photoResponse.photoSet.photos, nil)
		}
	}
}
