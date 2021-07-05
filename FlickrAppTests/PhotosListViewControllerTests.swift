//
//  PhotosListViewControllerTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation
import XCTest
@testable import FlickrApp

final class PhotosListViewControllerTests: XCTestCase {
    var photosListViewController: PhotosListViewController!
    var searchHistoryRepository: UserDefaultSearchHistoryRepository!
    override func setUp() {
        super.setUp()
        photosListViewController =  PhotosListBuilder.viewController()
        searchHistoryRepository = UserDefaultSearchHistoryRepository()
        
        // Arrange: setup UINavigationController
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = UINavigationController(rootViewController: photosListViewController)
    }
    
    override func tearDown() {
        photosListViewController = nil
        _ = searchHistoryRepository.clearSearchHistory()
        
    }
    
    func test_search_success() {
        let expectation = XCTestExpectation()
        
        let mockSession = MockURLSession.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
        let repository = getMockWebPhotosRepository(mockSession: mockSession)
        let presenter = PhotosListPresenter(output: photosListViewController, photosRepository: repository)
        photosListViewController.presenter = presenter
        
        // fire search after load viewController and load search history
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presenter.search(for: "Car")
            
        }
        
        // Check the datasource after search result bind to CollectionView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.photosListViewController.collectionDataSource)
            XCTAssertNotNil(self.photosListViewController.collectionDataSource?.presenterInput)
            XCTAssertEqual(self.photosListViewController.collectionDataSource?.itemsForCollection.count, 10)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_searchHistory_success() {
        let expectation = XCTestExpectation()
        
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed0")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed1")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed2")
        searchHistoryRepository.saveSearchKeyword(searchKeyword: "Ahmed3")
        
        photosListViewController.getSearchHistory()
        
        // Check the datasource after search result bind to CollectionView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            XCTAssertNotNil(self.photosListViewController.collectionDataSource)
            XCTAssertNotNil(self.photosListViewController.collectionDataSource?.presenterInput)
            XCTAssertEqual(self.photosListViewController.collectionDataSource?.itemsForCollection.count, 4)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func getMockWebPhotosRepository(mockSession: MockURLSession) -> WebPhotosRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebPhotosRepository(client: mockAPIClient)
    }
}
