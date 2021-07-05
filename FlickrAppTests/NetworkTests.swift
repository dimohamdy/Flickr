//
//  NetworkTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

final class NetworkTests: XCTestCase {
    
    func test_GetItems_Success() throws {

        let mockAPIClient =  getMockAPIClient(fromJsonFile: "data")
        loadData(mockAPIClient: mockAPIClient) { (result: Result<FlickrPhoto, FlickrAppError>) in
            switch result {
            case .success(let data):
                guard let photos = data.photos else {
                    XCTFail("Can't get Data")
                    return
                }
                XCTAssertGreaterThan(photos.photos.count, 0)
            default:
                XCTFail("Can't get Data")
            }
        }
    }

    func test_NotGetData_Fail() throws {

        let mockAPIClient =  getMockAPIClient(fromJsonFile: "noData")
        loadData(mockAPIClient: mockAPIClient) { (result: Result<FlickrPhoto, FlickrAppError>) in
            switch result {
            case .success(let data):
                guard let photos = data.photos?.photos else {
                    XCTFail("Can't get Data")
                    return
                }
                XCTAssertEqual(photos.count, 0)
            default:
                XCTFail("Can't get Data")
            }
        }
    }

    private func getMockAPIClient(fromJsonFile file: String) -> APIClient {
        let mockSession = MockURLSession.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        return APIClient(withSession: mockSession)
    }

    private func loadData<T: Decodable>(mockAPIClient: APIClient, completion: @escaping (Result<T, FlickrAppError>) -> Void) {
        guard let path = APILinksFactory.API.search(text: "Car", perPage: 10, page: 1).path,
              let url = URL(string: path) else {
            return
        }
        mockAPIClient.loadData(from: url, completion: completion)
    }
    
}
