//
//  Photo.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

struct Photo: Codable {

    let id, secret, server: String
    let farm: Int
    let imagePath: String

	private enum CodingKeys: String, CodingKey {
		case farm
		case id
		case secret
		case server
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		farm = try values.decode(Int.self, forKey: .farm)
		id = try values.decode(String.self, forKey: .id)
		secret = try values.decode(String.self, forKey: .secret)
		server = try values.decode(String.self, forKey: .server)
        imagePath = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
	}
}
