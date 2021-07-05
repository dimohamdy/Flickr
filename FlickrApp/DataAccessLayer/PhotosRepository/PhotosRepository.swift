//
//  PhotosRepository.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

protocol PhotosRepository {

    func photos(for query: String, page: Int, completion: @escaping (Result< FlickrPhoto, FlickrAppError>) -> Void)
}
