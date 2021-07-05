//
//  SearchHistoryCollectionCell.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit

final class SearchHistoryCollectionCell: UICollectionViewCell, CellReusable {
    
    private var searchTermLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .systemBackground
    }
    
    private func setupViews() {
        addSubview(searchTermLabel)
        
        NSLayoutConstraint.activate([
            searchTermLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTermLabel.topAnchor.constraint(equalTo: topAnchor),
            searchTermLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchTermLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configCell(searchTerm: String) {
        searchTermLabel.text = searchTerm
    }
    
}
