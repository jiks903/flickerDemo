//
//  FlickrResponse.swift
//  DemoZeoauto
//
//  Created by Jeegnesh Solanki on 08/03/25.
//

import UIKit

// Model to decode Flickr API response
struct FlickrResponse: Codable {
    let photos: FlickrPhotos
}

struct FlickrPhotos: Codable {
    let photo: [FlickrImage]
}

struct FlickrImage: Codable {
    let id: String
    let server: String
    let secret: String
    let farm: Int
    
    var imageUrl: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}
