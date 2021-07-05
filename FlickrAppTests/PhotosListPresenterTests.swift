//
//  PhotosListPresenterTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

final class PhotosListPresenterTests: XCTestCase {
    var mockPhotosListPresenterOutput: MockPhotosListPresenterOutput!

    override func setUp() {
        mockPhotosListPresenterOutput = MockPhotosListPresenterOutput()
    }

    override func tearDown() {
        mockPhotosListPresenterOutput = nil
        Reachability.shared =  MockReachability(internetConnectionState: .satisfied)
    }

    func test_search_success() {
        let presenter = getPhotosListPresenter(fromJsonFile: "data")
        presenter.search(for: "car")
        XCTAssertEqual(mockPhotosListPresenterOutput.itemsForCollection.count, 10)
    }

    func test_loadMore_success() {
        let presenter = getPhotosListPresenter(fromJsonFile: "data")
        presenter.search(for: "car")
        presenter.loadMoreData(2)
        XCTAssertEqual(mockPhotosListPresenterOutput.itemsForCollection.count, 20)
    }

    func test_search_noResult() {
        let presenter = getPhotosListPresenter(fromJsonFile: "noData")
        presenter.search(for: "AnyTextToTest")
        XCTAssertEqual(mockPhotosListPresenterOutput.itemsForCollection.count, 0)
        if let error = mockPhotosListPresenterOutput.error as? FlickrAppError {
            switch error {
            case .noResults:
                XCTAssertTrue(true)
            default:
                XCTFail("the error isn't noResults")
            }
        }
    }

    func test_search_noInternetConnection() {
        Reachability.shared =  MockReachability(internetConnectionState: .unsatisfied)
        let presenter = getPhotosListPresenter(fromJsonFile: "noData")
        presenter.search(for: "AnyTextToTest")
        XCTAssertEqual(mockPhotosListPresenterOutput.itemsForCollection.count, 0)
        if let error = mockPhotosListPresenterOutput.error as? FlickrAppError {
            switch error {
            case .noInternetConnection:
                XCTAssertTrue(true)
            default:
                XCTFail("the error isn't noResults")
            }
        }
    }

    private func getMockWebPhotosRepository(mockSession: MockURLSession) -> WebPhotosRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebPhotosRepository(client: mockAPIClient)
    }

    private func getPhotosListPresenter(fromJsonFile file: String) -> PhotosListPresenter {
        let mockSession = MockURLSession.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebPhotosRepository(mockSession: mockSession)
        return PhotosListPresenter(output: mockPhotosListPresenterOutput, photosRepository: repository)
    }
}

final class MockPhotosListPresenterOutput: UIViewController, PhotosListPresenterOutput {
    func clearCollection() {

    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {

    }

    var itemsForCollection: [ItemCollectionViewCellType] = []
    var error: Error!

    func updateData(error: Error) {
        self.error = error
    }

    func updateData(itemsForCollection: [ItemCollectionViewCellType]) {
        self.itemsForCollection = itemsForCollection
    }
}
