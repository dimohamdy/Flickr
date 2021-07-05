//
//  FlickrAppError.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

enum FlickrAppError: Error {
    case failedConnection
    case wrongURL
    case noResults
    case noInternetConnection
    case runtimeError(String)
    case parseError
    case fileNotFound

    var localizedDescription: String {
        switch self {
        case .noResults:
            return Strings.noPhotosErrorTitle.localized()
        case .noInternetConnection:
            return Strings.noInternetConnectionTitle.localized()
        default:
            return Strings.commonGeneralError.localized()
        }
    }
}
