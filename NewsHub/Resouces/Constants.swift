//
//  Constants.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

enum Constants {
    enum StyleDefaults {
        static let articleCellHeight: CGFloat = 340
        static let cornerRadius: CGFloat = 20
    }

    enum API {
        static let articlesPerPage = 30
        static let apiKey = "5bcf4740654b468bb7330f06e73411da"
        static let baseUrl = "https://newsapi.org/"
        static let headLines = baseUrl + "v2/top-headlines"
        static let sources = headLines + "/sources"
    }

    enum SystemImage: String {
        case bookmarkFill = "bookmark.fill"
        case bookmark
        case note
        case noteText = "note.text"
        case magnifyingglass
        case textMagnifyingglass = "text.magnifyingglass"

        var image: UIImage? { UIImage(systemName: rawValue) }
    }
}
