//
//  UIImageViewDownloadImageTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp
import Kingfisher

final class UIImageViewDownloadImageTests: XCTestCase {

    var imageView: UIImageView!

    override func setUp() {
        imageView = UIImageView()
    }

    override func tearDown() {
        KingfisherManager.shared.cache.clearCache()
        imageView.kf.cancelDownloadTask()
        imageView = nil
    }

    func test_downloadImage() {
        let expectation = XCTestExpectation()

        XCTAssertNil(imageView.image)
        imageView.download(from: "https://pbs.twimg.com/profile_images/1378562260872880136/TJNPzZbX_400x400.jpg")
        XCTAssertNotNil(imageView.image, "imageView have placeholder")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotEqual(UIImage(named: "place_holder"), self.imageView.image, "imageView have the downloaded image")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6)

    }

    func test_cancelDownloadImage() {
        imageView.download(from: "https://pbs.twimg.com/profile_images/1378562260872880136/TJNPzZbX_400x400.jpg")
        XCTAssertNotNil( imageView.kf.taskIdentifier)
        imageView.kf.cancelDownloadTask()
        XCTAssertNil(imageView.kf.taskIdentifier)
        XCTAssertEqual(UIImage(named: "place_holder"), imageView.image, "imageView have only placeholder")

    }
}
