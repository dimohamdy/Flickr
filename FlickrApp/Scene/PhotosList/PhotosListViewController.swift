//
//  PhotosListViewController.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit

final class PhotosListViewController: UIViewController {

    private(set) var collectionDataSource: PhotosCollectionViewDataSource?
    
    // MARK: Outlets
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 90, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.identifier)
        collectionView.register(SearchHistoryCollectionCell.self, forCellWithReuseIdentifier: SearchHistoryCollectionCell.identifier)
        collectionView.register(HistoryHeaderCollectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HistoryHeaderCollectionCell.identifier)
        collectionView.tag = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var presenter: PhotosListPresenterInput?
    
    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        getSearchHistory()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(photosCollectionView)
        NSLayoutConstraint.activate([
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        configureSearchController()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationItem.title = Strings.flikerTitle.localized()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.hidesBarsOnSwipe = true

    }

    private func configureSearchController() {
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for photos"
        definesPresentationContext = true
    }
}

// MARK: UISearch Delegates

extension PhotosListViewController {

    func getSearchHistory() {
        presenter?.getSearchHistory()
    }

}

// MARK: - PhotosListPresenterOutput
extension PhotosListViewController: PhotosListPresenterOutput {

    func clearCollection() {
        DispatchQueue.main.async {
            self.collectionDataSource = nil
            self.photosCollectionView.dataSource = nil
            self.photosCollectionView.dataSource = nil
            self.photosCollectionView.reloadData()
        }
    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {
        clearCollection()
        photosCollectionView.setEmptyView(emptyPlaceHolderType: emptyPlaceHolderType, completionBlock: { [weak self] in
            if let text = self?.searchController.searchBar.text, !text.isEmpty, text.count >= 3 {
                self?.presenter?.search(for: text)
            }
        })
    }

    func updateData(error: Error) {
        switch error as? FlickrAppError {
        case .noResults:
            emptyState(emptyPlaceHolderType: .noResults)
        case .noInternetConnection:
            emptyState(emptyPlaceHolderType: .noInternetConnection)
        default:
            emptyState(emptyPlaceHolderType: .error(message: error.localizedDescription))
        }
    }

    func updateData(itemsForCollection: [ItemCollectionViewCellType]) {
        DispatchQueue.main.async {
            // reset term text to searchBar in case it removed
            if case let .searchResult(term) = self.presenter?.state {
                self.searchController.searchBar.text = term
            }
            //Clear any placeholder view from collectionView
            self.photosCollectionView.restore()

            guard !itemsForCollection.isEmpty else {
                self.showReadyToSearch()
                return
            }

            // Reload the collectionView
            if self.collectionDataSource == nil {
                self.collectionDataSource = PhotosCollectionViewDataSource(presenterInput: self.presenter, itemsForCollection: itemsForCollection)
                self.photosCollectionView.dataSource = self.collectionDataSource
                self.photosCollectionView.delegate = self.collectionDataSource
                self.photosCollectionView.reloadData()
            } else {

                // Reload only the updated cells

                //Get the inserted new cells
                let fromIndex = self.collectionDataSource?.itemsForCollection.count ?? 0
                let toIndex = itemsForCollection.count

                let indexes = (fromIndex ..< toIndex).map { row -> IndexPath in
                    return IndexPath(row: row, section: 0)
                }

                self.collectionDataSource?.itemsForCollection = itemsForCollection
                self.photosCollectionView.performBatchUpdates {
                    self.photosCollectionView.insertItems(at: indexes)
                }
            }

        }

    }

    private func showReadyToSearch() {
        photosCollectionView.setEmptyView(emptyPlaceHolderType: .readyToSearch, completionBlock: { [weak self] in
            self?.searchController.isActive = true
        })
    }
}

// MARK: UIBarPositioningDelegate
extension PhotosListViewController: UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: UISearchBarDelegate
extension PhotosListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        getSearchHistory()
    }
}

extension PhotosListViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchController.dismiss(animated: true)
        getSearchHistory()
        return true
    }
}

// MARK: UISearchControllerDelegate
extension PhotosListViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchController.searchBar.becomeFirstResponder()
            self.getSearchHistory()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text, !text.isEmpty, text.count >= 3 {
            presenter?.search(for: text)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getSearchHistory()
        }
    }

}
