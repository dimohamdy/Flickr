//
//  AppDelegate.swift
//  FlickrApp
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Reachability.shared.startNetworkReachabilityObserver()
        window = UIWindow(frame: UIScreen.main.bounds)
        EntryPoint().initSplashScreen(window: window!)
        return true
    }

}
