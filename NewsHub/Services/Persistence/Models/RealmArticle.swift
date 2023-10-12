//
//  RealmArticle.swift
//  NewsHub
//
//  Created by Anton Petrov on 11.10.2023.
//

import RealmSwift

final class RealmArticle: Object {
    @Persisted(primaryKey: true) var url: String?
    @Persisted var sourceId: String?
    @Persisted var sourceName: String?
    @Persisted var author: String?
    @Persisted var title: String?
    @Persisted var briefDescription: String?
    @Persisted var urlToImage: String?
    @Persisted var publishedAt: String?
    @Persisted var content: String?
}
