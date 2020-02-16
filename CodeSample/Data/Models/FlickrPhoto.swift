//
//  FlickrPhoto.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/5/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

/// `FlickrPhoto` is a photo pulled from Flickr. The properties on an instance allow a source URL to be constructed.
class FlickrPhoto: Decodable {
	// MARK: enums

	/// Image sizes available from Flickr. Sizes are defined [here](https://www.flickr.com/services/api/misc.urls.html).
	///
	/// - smallSquare: small square 75x75
	/// - largeSquare: large square 150x150
	/// - thumbnail: thumbnail, 100 on longest side
	/// - small240: small, 240 on longest side
	/// - small320: small, 320 on longest side
	/// - medium500: medium, 500 on longest side
	/// - medium640: medium 640, 640 on longest side
	/// - medium800: medium 800, 800 on longest side
	/// - large1024: large, 1024 on longest side*
	/// - large1600: large 1600, 1600 on longest side
	/// - large2048: large 2048, 2048 on longest side
	/// - original: original image, either a jpg, gif or png, depending on source format
	enum Size: String {
		case smallSquare = "s"
		case largeSquare = "q"
		case thumbnail = "t"
		case small240 = "m"
		case small320 = "n"
		case medium500 = "-"
		case medium640 = "z"
		case medium800 = "c"
		case large1024 = "b"
		case large1600 = "h"
		case large2048 = "k"
		case original = "o"
	}

	// MARK: properties
	let id: String
	let owner: String
	let secret: String
	let server: String
	let farm: Int
	let title: String
	var isPublic = false
	var isFriend = false
	var isFamily = false

	private enum CodingKeys: String, CodingKey {
		case id
		case owner
		case secret
		case server
		case farm
		case title
		case isPublic = "ispublic"
		case isFriend = "isfriend"
		case isFamily = "isfamily"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		id = try container.decode(String.self, forKey: .id)
		owner = try container.decode(String.self, forKey: .owner)
		secret = try container.decode(String.self, forKey: .secret)
		server = try container.decode(String.self, forKey: .server)
		farm = try container.decode(Int.self, forKey: .farm)
		title = try container.decode(String.self, forKey: .title)
		isPublic = try container.decode(Int.self, forKey: .isPublic) == 1 ? true : false
		isFriend = try container.decode(Int.self, forKey: .isFriend) == 1 ? true : false
		isFamily = try container.decode(Int.self, forKey: .isFamily) == 1 ? true : false
	}


	/// Formats the properties of the photo to form a source URL string.
	/// NOTE: Images are not guaranteed to support every size. Either verify that an image is returned from the
	/// provided source or [check what sizes are available](https://www.flickr.com/services/api/flickr.photos.getSizes.html).
	///
	/// - Parameter size: The desired image size. Defaults to original sizing.
	/// - Returns: A formatted source URL for the photo
	func source(size: Size? = nil) -> String {
		if let size = size {
			return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).jpg"
		} else {
			return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
		}
	}
}

/// `FlickrPhotoSet` contains the array of photos retrieved from a photo request and also includes pagination information.
class FlickrPhotoSet: Decodable {
	// MARK: properties
	let page: Int
	let pages: Int
	let perPage: Int
	let total: Int
	let photos: [FlickrPhoto]

	private enum CodingKeys: String, CodingKey {
		case page
		case pages
		case perPage = "perpage"
		case total
		case photos = "photo"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		page = try container.decode(Int.self, forKey: .page)
		pages = try container.decode(Int.self, forKey: .pages)
		perPage = try container.decode(Int.self, forKey: .perPage)
		// This roundabout mapping is needed because the Flickr API is inconsistent in the type it returns for `total`
		do {
			total = try container.decode(Int.self, forKey: .total)
		} catch {
			total = try Int(container.decode(String.self, forKey: .total)) ?? 0
		}

		photos = try container.decode([FlickrPhoto].self, forKey: .photos)
	}
}

/// `FlickrPhotoResponse` is the root entity found in a successful request to the Flickr API
class FlickrPhotoResponse: Decodable {
	// MARK: properties
	let photoSet: FlickrPhotoSet

	private enum CodingKeys: String, CodingKey {
		case photoSet = "photos"
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		photoSet = try container.decode(FlickrPhotoSet.self, forKey: .photoSet)
	}
}
