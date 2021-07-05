//
//  SearchHistory.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

protocol SearchHistoryRepository {
    func getSearchHistory() -> [String]
    func saveSearchKeyword(searchKeyword: String) -> [String]
    func clearSearchHistory() -> [String]
}
