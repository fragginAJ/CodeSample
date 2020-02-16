//
//  Endpoint.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/5/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONObject = [String: Any]

/// An `Endpoint` defines a resource on the backend and how to build a network request accessing it
protocol Endpoint {
	/// The path of the resource, typically appended to a base url.
	var path: String { get }
	/// The HTTP method to use when interacting with the target resource.
	var method: Alamofire.HTTPMethod { get }
	/// Parameters associated with the request to the resource.
	var parameters: JSONObject? { get }
	/// Encoding to use when converting the Target into a URLRequest.
	var parameterEncoding: ParameterEncoding { get }
}
