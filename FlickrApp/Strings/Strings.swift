//
//  Strings.swift
//  FlickrApp
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import Foundation

enum Strings: String {

    // MARK: Errors
    case commonGeneralError = "Common_GeneralError"
    case commonInternetError = "Common_InternetError"

    // MARK: Fliker
    case flikerTitle = "Fliker_Title"
    case searchPlaceholder = "Search_Placeholder"

    // MARK: Internet Errors
    case noInternetConnectionTitle = "No_Internet_Connection_Title"
    case noInternetConnectionSubtitle = "No_Internet_Connection_Subtitle"

    // MARK: Photos Errors
    case noPhotosErrorTitle = "No_Photos_Error_Title"
    case noPhotosErrorSubtitle = "No_Photos_Error_Subtitle"

    // MARK: Ready to Search
    case readyToSearchTitle = "Ready_To_Search_Title"
    case readyToSearchSubtitle = "Ready_To_Search_Subtitle"

    // MARK: Collection Headers
    case searchHistoryTitle = "Search_History_Title"
    case searchResultTitle = "Search_Result_Title"

    case tryAction = "Try_Action"
    case searchAction = "Search_Action"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
