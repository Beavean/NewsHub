//
//  SavedViewModel.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

final class SavedViewModel {
    private var articles: [RealmArticle] = []
    private(set) var filteredArticles: [RealmArticle] = []
    private(set) var realmManager: RealmManagerProtocol

    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }

    func getWebViewModel(forIndex index: Int) -> WebViewModel? {
        guard let article = articles.safeElement(at: index) else { return nil }
        return WebViewModel(articleRealm: article, realmManager: realmManager)
    }

    func fetchSavedArticles() {
        articles = realmManager.getAllSavedArticles()
        filteredArticles = articles
    }

    func filterArticles(with query: String) {
        let lowercasedQuery = query.lowercased()
        if query.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter {
                $0.title?.lowercased().contains(lowercasedQuery) == true
                    || $0.description.lowercased().contains(lowercasedQuery) == true
            }
        }
    }

    func deleteArticle(at index: Int) {
        let article = filteredArticles[index]
        realmManager.deleteArticle(article)
        filteredArticles.remove(at: index)
    }
}
