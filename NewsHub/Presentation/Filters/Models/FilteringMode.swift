//
//  FilteringMode.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

enum FilteringMode: Int, CaseIterable {
    case filters
    case sources

    var titles: String {
        switch self {
        case .filters:
            return LocalizedString.filters.localized ?? "1"
        case .sources:
            return LocalizedString.sources.localized ?? "2"
        }
    }
}
