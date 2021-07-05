//
//  Photos.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

struct Photos: Codable {
    
    let page: Int
    let pages: Int
    let photos: [Photo]
    
    private enum CodingKeys: String, CodingKey {
        
        case page
        case pages
        case photos = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        pages = try values.decode(Int.self, forKey: .pages)
        photos = try values.decode([Photo].self, forKey: .photos)
    }
}
