//
//  ArticleCellViewModel.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

final class ArticleCellViewModel {
    // MARK: - Properties

    private(set) var title: String?
    private(set) var description: String?
    private(set) var sourceName: String?
    private(set) var author: String?
    private(set) var imageUrl: String?
    private(set) var shouldHideSaveButton: Bool = false
    private var article: Article?
    private let realmManager: RealmManagerProtocol
    var isSaved: Bool {
        guard let article else { return false }
        return realmManager.isArticleSaved(article)
    }

    // MARK: - Initialization

    init(from article: Article, realmManager: RealmManagerProtocol) {
        title = article.title
        description = article.description
        sourceName = article.source?.name
        if article.source?.name?.lowercased() != article.author?.lowercased() {
            author = article.author
        }
        imageUrl = article.urlToImage
        self.article = article
        self.realmManager = realmManager
    }

    init(from articleRealm: RealmArticle, realmManager: RealmManagerProtocol) {
        title = articleRealm.title
        description = articleRealm.briefDescription
        sourceName = articleRealm.sourceName
        if articleRealm.sourceName?.lowercased() != articleRealm.author?.lowercased() {
            author = articleRealm.author
        }
        if let urlString = articleRealm.urlToImage {
            imageUrl = urlString
        }
        shouldHideSaveButton = true
        self.realmManager = realmManager
    }

    // MARK: - Modeling methods

    func toggleSaveStatus() {
        guard let article else { return }
        if isSaved {
            realmManager.deleteArticle(article)
        } else {
            realmManager.saveArticle(article)
        }
    }
}
