//
//  CellReusable.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

protocol CellReusable {
    static var identifier: String { get }
}

extension CellReusable {
    static var identifier: String {
        return "\(self)"
    }
}
