//
//  UserErrors.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

enum UserError: Error {
    case noConnection
    case noSearchResults
    case serverError

    var userLocalizedDescription: String? {
        switch self {
        case .noConnection:
            return LocalizedString.noConnection.localized
        case .noSearchResults:
            return LocalizedString.noResults.localized
        case .serverError:
            return LocalizedString.serverError.localized
        }
    }
}
