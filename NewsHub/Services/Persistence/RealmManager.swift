//
//  RealmManager.swift
//  NewsHub
//
//  Created by Anton Petrov on 11.10.2023.
//

import RealmSwift

protocol RealmManagerProtocol {
    func saveArticle(_ article: Article)
    func getAllSavedArticles() -> [RealmArticle]
    func deleteArticle(_ article: Article)
    func isArticleSaved(_ article: Article) -> Bool
    func deleteArticle(_ articleRealm: RealmArticle)
}

final class RealmManager: RealmManagerProtocol {
    init() {
        setupRealm()
    }

    private var realm: Realm?

    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Failed to initialize Realm: \(error)")
            realm = nil
        }
    }

    func saveArticle(_ article: Article) {
        guard let realm else {
            print("Realm instance is nil")
            return
        }
        do {
            try realm.write {
                let articleRealm = RealmArticle()
                articleRealm.url = article.url
                articleRealm.sourceId = article.source?.id
                articleRealm.sourceName = article.source?.name
                articleRealm.author = article.author
                articleRealm.title = article.title
                articleRealm.briefDescription = article.description
                articleRealm.urlToImage = article.urlToImage
                articleRealm.publishedAt = article.publishedAt
                articleRealm.content = article.content
                realm.add(articleRealm)
            }
        } catch {
            print("Failed to save article: \(error)")
        }
    }

    func getAllSavedArticles() -> [RealmArticle] {
        guard let realm else { return [] }
        return Array(realm.objects(RealmArticle.self))
    }

    func deleteArticle(_ article: Article) {
        guard let realm, let url = article.url else { return }
        if let articleToDelete = realm.object(ofType: RealmArticle.self, forPrimaryKey: url) {
            try? realm.write {
                realm.delete(articleToDelete)
            }
        }
    }

    func isArticleSaved(_ article: Article) -> Bool {
        guard let realm, let url = article.url else { return false }
        return realm.object(ofType: RealmArticle.self, forPrimaryKey: url) != nil
    }

    func deleteArticle(_ articleRealm: RealmArticle) {
        guard let realm else { return }
        try? realm.write {
            realm.delete(articleRealm)
        }
    }
}
