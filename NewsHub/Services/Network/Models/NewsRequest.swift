//
//  NewsRequest.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import Foundation

struct NewsRequest {
    var searchQuery: String? = "a"
    var country: Country?
    var category: Category?
    var sources = [String]()
    var pageSize: Int?
    var page: Int = 1

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let searchQuery = searchQuery {
            items.append(URLQueryItem(name: "q", value: searchQuery))
        }
        if let country = country {
            items.append(URLQueryItem(name: "country", value: country.rawValue))
        }
        if let category = category {
            items.append(URLQueryItem(name: "category", value: category.rawValue))
        }
        if !sources.isEmpty {
            let sourcesValue = sources.joined(separator: ",")
            items.append(URLQueryItem(name: "sources", value: sourcesValue))
        }
        if let pageSize = pageSize {
            items.append(URLQueryItem(name: "pageSize", value: String(pageSize)))
        }
        items.append(URLQueryItem(name: "page", value: String(page)))
        return items
    }
}
