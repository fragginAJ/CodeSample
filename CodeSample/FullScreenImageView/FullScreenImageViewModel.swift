//
//  FullScreenImageViewModel.swift
//  CodeSample
//
//  Created by AJ Fragoso on 5/30/24.
//  Copyright © 2024 AJ Fragoso. All rights reserved.
//

import Foundation

struct FullScreenImageViewModel {
    var photo: FlickrPhoto
    
    var standardQualityPhotoURL: URL? {
        return URL(string: photo.source())
    }
    
    var highQualityPhotoURL: URL? {
        return URL(string: photo.source(size: FlickrPhoto.Size.large1024))
    }
    
    var photoTitle: String {
        return photo.title
    }
}
