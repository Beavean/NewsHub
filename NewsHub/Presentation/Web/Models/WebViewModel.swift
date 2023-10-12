//
//  WebViewModel.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

final class WebViewModel {
    private var article: Article?
    private let realmManager: RealmManagerProtocol

    var isSaved: Bool {
        guard let article else { return false }
        return realmManager.isArticleSaved(article)
    }

    var url: URL? {
        URL(string: article?.url ?? "")
    }

    var sourceName: String {
        article?.source?.name ?? LocalizedString.article.localized ?? ""
    }

    init(article: Article, realmManager: RealmManagerProtocol) {
        self.article = article
        self.realmManager = realmManager
    }

    init(articleRealm: RealmArticle, realmManager: RealmManagerProtocol) {
        article = Article(
            source: Source(id: articleRealm.sourceId, name: articleRealm.sourceName),
            author: articleRealm.author,
            title: articleRealm.title,
            description: articleRealm.briefDescription,
            url: articleRealm.url,
            urlToImage: articleRealm.urlToImage,
            publishedAt: articleRealm.publishedAt,
            content: articleRealm.content
        )
        self.realmManager = realmManager
    }

    func toggleSaveStatus() {
        guard let article else { return }
        if isSaved {
            realmManager.deleteArticle(article)
        } else {
            realmManager.saveArticle(article)
        }
    }
}
