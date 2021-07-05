//
//  UserDefaultSearchHistoryRepositoryTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

final class UserDefaultSearchHistoryRepositoryTests: XCTestCase {
    var searchHistoryRepository: UserDefaultSearchHistoryRepository!
    
    override func setUp() {
        searchHistoryRepository = UserDefaultSearchHistoryRepository()
        _ = searchHistoryRepository.clearSearchHistory()
    }
    
    func testGetItemsFromAPI() {
        // Act: get data from API .
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed0")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed1")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed2")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed3")
        let searchTerms = searchHistoryRepository.getSearchHistory()
        // Assert: Verify it's have a data.
        XCTAssertEqual(searchTerms.count, 4)
        
    }
}
