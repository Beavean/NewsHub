//
//  SourcesResponse.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import Foundation

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}
