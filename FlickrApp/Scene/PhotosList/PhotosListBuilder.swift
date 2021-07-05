//
//  PhotosListBuilder.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit

struct PhotosListBuilder {
    
    static func viewController() -> PhotosListViewController {
        let viewController: PhotosListViewController = PhotosListViewController()
        let presenter = PhotosListPresenter(output: viewController)
        viewController.presenter = presenter
        return viewController
    }
}
