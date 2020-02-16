//
//  FlickrEndpoint.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/6/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import Alamofire

/// `FlickrEndpoint` is a resource available on the [Flickr API](https://www.flickr.com/services/api/).
///
/// - searchPhotosByLocation: Search for photos within 5 km of the supplied coordinates
/// - trendingPhotos: Photos from the Flickr editorial gallery
enum FlickrEndpoint: Endpoint {
	case searchPhotosByLocation(latitude: Double, longitude: Double)
	case trendingPhotos

	var path: String {
		switch self {
		case .searchPhotosByLocation(_, _):
			return "rest/"
		case .trendingPhotos:
			return "rest/"
		}
	}

	var method: HTTPMethod {
		switch self {
		case .searchPhotosByLocation(_, _):
			return .get
		case .trendingPhotos:
			return .get
		}
	}

	var parameters: JSONObject? {
		guard let apiKey = FlickrConstants.shared.apiKey else {
			fatalError("Flickr API key must not be nil. Be sure to set this value with LocationViewController.init(flickrAPIKey:) before querying the API.")
		}

		switch self {
		case .searchPhotosByLocation(let latitude, let longitude):
			return [FlickrConstants.ParameterKeys.method.rawValue: "flickr.photos.search",
					FlickrConstants.ParameterKeys.latitude.rawValue: latitude,
					FlickrConstants.ParameterKeys.longitude.rawValue: longitude,
					FlickrConstants.ParameterKeys.perPage.rawValue: 20,
					FlickrConstants.ParameterKeys.format.rawValue: "json",
					FlickrConstants.ParameterKeys.noJSONCallback.rawValue: true,
					FlickrConstants.ParameterKeys.apiKey.rawValue: apiKey]
		case .trendingPhotos:
			return [FlickrConstants.ParameterKeys.method.rawValue: "flickr.galleries.getPhotos",
					FlickrConstants.ParameterKeys.galleryID.rawValue: "72157665473890908",
					FlickrConstants.ParameterKeys.format.rawValue: "json",
					FlickrConstants.ParameterKeys.noJSONCallback.rawValue: true,
					FlickrConstants.ParameterKeys.apiKey.rawValue: apiKey]
		}
	}

	var parameterEncoding: ParameterEncoding {
		switch self.method {
		case .get:
			return URLEncoding(destination: .queryString)
		default:
			return JSONEncoding.default
		}
	}
}
