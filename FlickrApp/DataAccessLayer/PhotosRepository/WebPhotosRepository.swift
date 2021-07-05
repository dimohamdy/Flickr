//
//  WebPhotosRepository.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

final class WebPhotosRepository: PhotosRepository {
    
    let client: APIClient
    init(client: APIClient = APIClient()) {
        self.client =  client
    }
    
    func photos(for query: String, page: Int, completion: @escaping (Result< FlickrPhoto, FlickrAppError>) -> Void) {
        if  let path = APILinksFactory.API.search(text: query, perPage: Constant.pageSize, page: page).path {
            guard let url = URL(string: path) else {
                completion(.failure(.wrongURL))
                return }
            client.loadData(from: url) { (result: Result<FlickrPhoto, FlickrAppError>) in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
