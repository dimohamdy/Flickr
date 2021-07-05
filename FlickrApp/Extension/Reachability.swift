//
//  Reachability.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Network
import Foundation

class Reachability {

    static var shared = Reachability()
    lazy private var monitor = NWPathMonitor()

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    func startNetworkReachabilityObserver() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                NotificationCenter.default.post(name: Notifications.Reachability.connected.name, object: nil)
            } else if path.status == .unsatisfied {
                NotificationCenter.default.post(name: Notifications.Reachability.notConnected.name, object: nil)
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}
