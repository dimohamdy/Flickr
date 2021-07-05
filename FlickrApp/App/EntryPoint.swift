//
//  EntryPoint.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit

struct EntryPoint {
    
    func initSplashScreen(window: UIWindow) {
        window.rootViewController = UINavigationController(rootViewController: PhotosListBuilder.viewController())
        window.makeKeyAndVisible()
    }
    
}
