//
//  FlickrPhoto.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {

	let photos: Photos?
	let stat: String?

	private enum CodingKeys: String, CodingKey {
		case photos
		case stat
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try? values.decodeIfPresent(Photos.self, forKey: .photos)
		stat = try? values.decodeIfPresent(String.self, forKey: .stat)
	}
}
