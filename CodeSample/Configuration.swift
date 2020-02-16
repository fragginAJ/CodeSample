//
//  Configuration.swift
//  CodeSample
//
//  Created by Alejandro Fragoso on 2/16/20.
//  Copyright © 2020 AJ Fragoso. All rights reserved.
//

import Foundation

/// `Configuration` loads values from an xcconfig file, which serves as a repository for API keys or other environment vairables.
/// The concept is described in this [NSHipster article](https://nshipster.com/xcconfig/)
enum Configuration {
    enum Key: String {
        case flickrApiKey = "FLICKR_API_KEY"
    }
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: Key) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key.rawValue) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
