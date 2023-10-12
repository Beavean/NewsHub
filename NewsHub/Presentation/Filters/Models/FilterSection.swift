//
//  FilterSection.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

enum FilterSection: Int, CaseIterable {
    case category
    case country

    var rowCount: Int {
        switch self {
        case .country: return Country.allCases.count
        case .category: return Category.allCases.count
        }
    }

    func titleForRow(_ row: Int) -> String {
        switch self {
        case .country: return Country.allCases[row].fullName
        case .category: return Category.allCases[row].title
        }
    }

    var sectionTitle: String {
        switch self {
        case .country: return LocalizedString.country.rawValue
        case .category: return LocalizedString.category.rawValue
        }
    }
}
