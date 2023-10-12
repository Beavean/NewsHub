//
//  LocalizedStrings.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import Foundation

enum LocalizedString: String {
    case searchTab = "Search"
    case savedTab = "Saved"
    case filterButton = "Filter"
    case searchPlaceholder = "Search..."
    case loadingArticles = "Loading articles..."
    case sources = "Sources"
    case country = "Country"
    case category = "Category"
    case save = "Save"
    case clear = "Clear"
    case filters = "Filters"
    case article = "Article"
    case reset = "Reset"
    case noConnection = "No connection"
    case noResults = "No search results found"
    case serverError = "Server error"

    var localized: String? {
        rawValue
    }
}
