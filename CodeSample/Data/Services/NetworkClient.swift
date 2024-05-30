//
//  NetworkClient.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/4/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import Alamofire

/// `NetworkClient` is responsible for initiating and handling the results of all network requests.
/// The `request` function should only be used by extensions of `NetworkClient`. See `NetworkClient+FlickrProvider`.
struct NetworkClient {
	// MARK: properties
	private let baseURL = "https://www.flickr.com/services/"
	private let decoder = JSONDecoder()

	/// The default `NetworkClient`
	static var shared: NetworkClient {
		return NetworkClient()
	}

	/// Builds the full URL string for the `Endpoint`
	///
	/// - Parameter endpoint: The resource to access
	private func url(for endpoint: Endpoint) -> String {
		return baseURL + endpoint.path
	}

	/// Execute a network request.
	///
	/// - Parameters:
	///   - endpoint: The resource to target
	///   - completionHandler: Executable closure at the end of the request, success or failure.
	func request<T: Decodable>(endpoint: Endpoint,
							   completionHandler: @escaping (T?, Error?) -> Void) {
        AF.request(url(for: endpoint),
                   method: endpoint.method,
                   parameters: endpoint.parameters,
                   encoding: endpoint.parameterEncoding,
                   headers: nil)
        .validate()
        .responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                do {
                    completionHandler(try self.decoder.decode(T.self, from: value), nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
        })
	}
}
