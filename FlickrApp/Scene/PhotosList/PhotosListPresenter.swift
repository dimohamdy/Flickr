//
//  PhotosListPresenter.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

protocol PhotosListPresenterInput: BasePresenterInput {
    func search(for text: String)
    func loadMoreData(_ page: Int)
    func getSearchHistory()
    var state: State { get set }
}

protocol PhotosListPresenterOutput: BasePresenterOutput {
    func clearCollection()
    func updateData(error: Error)
    func updateData(itemsForCollection: [ItemCollectionViewCellType])
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType)
}

enum State {
    case searchHistory
    case searchResult(term: String)
}

final class PhotosListPresenter {
    
    // MARK: Injections
    private weak var output: PhotosListPresenterOutput?
    let photosRepository: WebPhotosRepository
    var state: State = .searchHistory {
        didSet {
            output?.clearCollection()
        }
    }

    fileprivate var page: Int = 1
    fileprivate var canLoadMore = true
    // internal
    private var itemsForCollection: [ItemCollectionViewCellType] = [ItemCollectionViewCellType]()
    
    // MARK: LifeCycle 
    init(output: PhotosListPresenterOutput, photosRepository: WebPhotosRepository = WebPhotosRepository()) {
        
        self.output = output
        self.photosRepository = photosRepository
        [Notifications.Reachability.connected.name, Notifications.Reachability.notConnected.name].forEach { (notification) in
            NotificationCenter.default.addObserver(self, selector: #selector(changeInternetConnection), name: notification, object: nil)
        }
    }
}

// MARK: - PhotosListPresenterInput
extension PhotosListPresenter: PhotosListPresenterInput {

    func search(for text: String) {
        state = .searchResult(term: text)
        itemsForCollection = []
        self.page = 1
        self.canLoadMore = true
        let userDefaultSearchHistoryRepository = UserDefaultSearchHistoryRepository()
        userDefaultSearchHistoryRepository.saveSearchKeyword(searchKeyword: text)
        getData(for: text)
    }
    
    func loadMoreData(_ page: Int) {
        if self.page <= page && canLoadMore == true {
            self.page = page
            if case .searchResult(let query) = state {
                getData(for: query)
            }
        }
    }
    
    func getSearchHistory() {
        state = .searchHistory
        let userDefaultSearchHistoryRepository = UserDefaultSearchHistoryRepository()
        let searchTerms = userDefaultSearchHistoryRepository.getSearchHistory()
        output?.updateData(itemsForCollection: createItemsForCollection(searchTerms: searchTerms))
    }

    @objc
    private func changeInternetConnection(notification: Notification) {
        if notification.name == Notifications.Reachability.notConnected.name {
            output?.showError(title: Strings.noInternetConnectionTitle.localized(), subtitle: Strings.noInternetConnectionSubtitle.localized())
            output?.updateData(error: FlickrAppError.noInternetConnection)
        } else {
            output?.emptyState(emptyPlaceHolderType: .readyToSearch)
        }
    }
}

// MARK: Setup

extension PhotosListPresenter {
    
    private func getData(for query: String) {

        guard Reachability.shared.isConnected else {
            self.output?.updateData(error: FlickrAppError.noInternetConnection)
            return
        }
        output?.showLoading()
        canLoadMore = false
        
        photosRepository.photos(for: query, page: page) { [weak self] result in
            
            guard let self =  self else {
                return
            }
            self.output?.hideLoading()

            switch result {
            case .success(let searchResult):

                guard let photos = searchResult.photos, photos.page < photos.pages  else {
                    self.handleNoPhotos()
                    return
                }
                self.handleNewPhotos(photos: photos)
                self.canLoadMore = true

            case .failure(let error):
                self.output?.updateData(error: error)
            }
        }
    }
    
    private func handleNewPhotos(photos: Photos) {
        let newItems: [ItemCollectionViewCellType] = createItemsForCollection(photosArray: photos.photos)
        itemsForCollection.append(contentsOf: newItems)
        if itemsForCollection.isEmpty {
            output?.updateData(error: FlickrAppError.noResults)
        } else {
            output?.updateData(itemsForCollection: itemsForCollection)
        }
    }
    
    private func handleNoPhotos() {
        if  itemsForCollection.isEmpty {
            output?.updateData(error: FlickrAppError.noResults)
        }
    }

    private func createItemsForCollection(photosArray: [Photo]) -> [ItemCollectionViewCellType] {
        return photosArray.map { photo -> ItemCollectionViewCellType  in
            .photo(photo: photo)
        }
    }
    
    private func createItemsForCollection(searchTerms: [String]) -> [ItemCollectionViewCellType] {
        return searchTerms.map { searchTerm -> ItemCollectionViewCellType  in
            .search(term: searchTerm)
        }
    }
}
