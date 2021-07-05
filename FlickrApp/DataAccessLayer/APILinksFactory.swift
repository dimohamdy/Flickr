//
//  APILinksFactory.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

struct APILinksFactory {

    #warning("Replace your API Key in API_KEY ")
    #warning("I used to use Cocoakeys to save secret keys")
    
    static let apiKey: String = "API_KEY"
    private static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1"

    enum API {
        case search(text: String, perPage: Int, page: Int)

        var path: String? {
            switch self {
            case .search(let text, let perPage, let page):
                if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                    return APILinksFactory.baseURL + "&text=\(encodedText)&per_page=\(perPage)&page=\(page)"
                }
                return nil
            }
        }
    }
}
