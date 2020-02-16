//
//  MockData+Flickr.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/8/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

// MARK: - `FlickrProvider`
extension MockClient: FlickrProvider {
	func searchPhotos(latitude: Double, longitude: Double, completionHandler: @escaping ([FlickrPhoto], Error?) -> Void) {
		do {
			let response = try decoder.decode(FlickrPhotoResponse.self, from: mockPhotosReponseData())
			completionHandler(response.photoSet.photos, nil)
		} catch let error {
			completionHandler([], error)
		}
	}

	func trendingPhotos(completionHandler: @escaping ([FlickrPhoto], Error?) -> Void) {
		do {
			let response = try decoder.decode(FlickrPhotoResponse.self, from: mockPhotosReponseData())
			completionHandler(response.photoSet.photos, nil)
		} catch let error {
			completionHandler([], error)
		}
	}

	// MARK: helper functions
	private func mockPhotosReponseData() throws -> Data {
		let jsonData = try JSONSerialization.data(withJSONObject: mockPhotosResponseJSON(),
												  options: JSONSerialization.WritingOptions.prettyPrinted)
		return jsonData
	}

	private func mockPhotosResponseJSON() -> JSONObject {
		return [
			"photos": [
				"page": 1,
				"pages": 1,
				"perpage": 100,
				"total": 22,
				"photo": [[
					"id": "25408240053",
					"owner": "113500642@N04",
					"secret": "588cfe81c0",
					"server": "1529",
					"farm": 2,
					"title": "Portrait of Elisa",
					"ispublic": 1,
					"isfriend": 0,
					"isfamily": 0,
					"is_primary": 1,
					"has_comment": 0
					], [
						"id": "28146935493",
						"owner": "25182021@N05",
						"secret": "2a072a9c75",
						"server": "8692",
						"farm": 9,
						"title": "51/365",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "35639990174",
						"owner": "149220585@N04",
						"secret": "c8b508bc44",
						"server": "4339",
						"farm": 5,
						"title": "8032001394_20598bb98a_k",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "29594595132",
						"owner": "33303283@N03",
						"secret": "9a68c8e87c",
						"server": "8119",
						"farm": 9,
						"title": "michelle rosillo",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "32568694080",
						"owner": "101293888@N03",
						"secret": "b7a5d9cc14",
						"server": "2006",
						"farm": 3,
						"title": "NB6A1165PW",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "24822831872",
						"owner": "128878277@N06",
						"secret": "1e055f2403",
						"server": "1496",
						"farm": 2,
						"title": "cabbage",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "4736402015",
						"owner": "11104619@N07",
						"secret": "765bfcc731",
						"server": "4140",
						"farm": 5,
						"title": "shelter..",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "36895474614",
						"owner": "133906096@N03",
						"secret": "921e1a7a90",
						"server": "4510",
						"farm": 5,
						"title": "_DSC8816-3n-2",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "16777805078",
						"owner": "113362588@N06",
						"secret": "60e55180c4",
						"server": "8735",
						"farm": 9,
						"title": "IMG_7541",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "27836053533",
						"owner": "25182021@N05",
						"secret": "f2d9344ece",
						"server": "8635",
						"farm": 9,
						"title": "Red",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "25304478034",
						"owner": "113500642@N04",
						"secret": "55d6a23263",
						"server": "1674",
						"farm": 2,
						"title": "Spring",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "25963767506",
						"owner": "113500642@N04",
						"secret": "d2616d7aaf",
						"server": "1587",
						"farm": 2,
						"title": "Elisa",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "22391695233",
						"owner": "128878277@N06",
						"secret": "603d747f9d",
						"server": "5802",
						"farm": 6,
						"title": "wild rose...",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "25033981582",
						"owner": "128878277@N06",
						"secret": "9a3de8a2b7",
						"server": "1663",
						"farm": 2,
						"title": "the branch",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "22250878914",
						"owner": "128878277@N06",
						"secret": "f2ec357577",
						"server": "5785",
						"farm": 6,
						"title": "berry",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "20997186958",
						"owner": "128878277@N06",
						"secret": "548779e220",
						"server": "656",
						"farm": 1,
						"title": "Jo",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "17862086664",
						"owner": "24833783@N04",
						"secret": "5e1f19268b",
						"server": "415",
						"farm": 1,
						"title": "blossom",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "6994541085",
						"owner": "48760515@N04",
						"secret": "7045747a8c",
						"server": "7198",
						"farm": 8,
						"title": "Awaken, spring.",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "21648537366",
						"owner": "33303283@N03",
						"secret": "0f62812b85",
						"server": "5709",
						"farm": 6,
						"title": "lena.",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "7228575254",
						"owner": "7984580@N06",
						"secret": "126f3360c8",
						"server": "8148",
						"farm": 9,
						"title": "Printemps",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "26831401874",
						"owner": "86049280@N06",
						"secret": "c9a7a418e0",
						"server": "7202",
						"farm": 8,
						"title": "Fairytale",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					], [
						"id": "32225635706",
						"owner": "33303283@N03",
						"secret": "bc0b6ac70a",
						"server": "273",
						"farm": 1,
						"title": "alina kreuter.",
						"ispublic": 1,
						"isfriend": 0,
						"isfamily": 0,
						"is_primary": 0,
						"has_comment": 0
					]]
			],
			"stat": "ok"
		]
	}
}
