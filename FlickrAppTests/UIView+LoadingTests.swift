//
//  UIViewLoadingTests.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import XCTest
@testable import FlickrApp

final class UIViewLoadingTests: XCTestCase {
    var view: UIView!
    override func setUp() {
        view = UIView()
    }

    override func tearDown() {
        view = nil
    }

    func test_showLoading() {
        view.showLoadingIndicator()
        XCTAssertNotNil(view.viewWithTag(999999) )
        if let activityIndicatorView = view.viewWithTag(999999) as? UIActivityIndicatorView {
            XCTAssertTrue(activityIndicatorView.isAnimating)
            XCTAssertFalse(activityIndicatorView.isHidden)
        }
    }

    func test_dismissLoading() {
        view.dismissLoadingIndicator()
        XCTAssertNil(view.viewWithTag(999999) )
    }

}
