//
//  TabBarItem.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case search
    case saved

    var title: String? {
        switch self {
        case .search:
            return LocalizedString.searchTab.localized
        case .saved:
            return LocalizedString.savedTab.localized
        }
    }

    var image: UIImage? {
        switch self {
        case .search:
            return Constants.SystemImage.magnifyingglass.image
        case .saved:
            return Constants.SystemImage.note.image
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .search:
            return Constants.SystemImage.textMagnifyingglass.image
        case .saved:
            return Constants.SystemImage.noteText.image
        }
    }
}
