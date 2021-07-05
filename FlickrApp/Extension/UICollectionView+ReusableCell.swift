//
//  UICollectionView+ReusableCell.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit

extension UICollectionView {

    func dequeueReusableCell<T: CellReusable>(for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
}
