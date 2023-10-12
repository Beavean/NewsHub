//
//  Category.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

enum Category: String, CaseIterable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology

    var title: String {
        rawValue.capitalized
    }
}
