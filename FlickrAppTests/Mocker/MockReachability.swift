//
//  MockReachability.swift
//  FlickrAppTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Network
import Foundation
@testable import FlickrApp

final class MockReachability: Reachability {

    let internetConnectionState: NWPath.Status

    override var isConnected: Bool {
        return internetConnectionState == .satisfied
    }

    init(internetConnectionState: NWPath.Status) {
        self.internetConnectionState  = internetConnectionState
        super.init()
    }
}
