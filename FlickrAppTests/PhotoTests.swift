//
//  PhotoTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

final class PhotoTests: XCTestCase {

    private let photo = Data("""
    {"id":"51284607891","owner":"28826708@N03","secret":"4b61c08563","server":"65535","farm":66,"title":"1966 Charger hardtop Hemi","ispublic":1,"isfriend":0,"isfamily":0}
    """.utf8)

    func testDecoding_whenMissingRequiredKeys_itThrows() throws {
        try ["farm", "id", "secret", "server"].forEach { key in
            AssertThrowsKeyNotFound(key, decoding: Photo.self, from: try photo.json(deletingKeyPaths: key))
        }
    }

    func testDecoding_whenPhotoData_returnsAPhotoObject() throws {
       let photo =  try JSONDecoder().decode(Photo.self, from: photo)
        XCTAssertEqual(photo.farm, 66)
        XCTAssertEqual(photo.id, "51284607891")
        XCTAssertEqual(photo.secret, "4b61c08563")
        XCTAssertEqual(photo.server, "65535")
    }

    func AssertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data), file: file, line: line) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.", file: file, line: line)
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)", file: file, line: line)
            }
        }
    }
}

extension Data {
    func json(deletingKeyPaths keyPaths: String...) throws -> Data {
        let decoded = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as AnyObject

        for keyPath in keyPaths {
            decoded.setValue(nil, forKeyPath: keyPath)
        }

        return try JSONSerialization.data(withJSONObject: decoded)
    }
}
