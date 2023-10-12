//
//  SearchViewModel.swift
//  NewsHub
//
//  Created by Anton Petrov on 11.10.2023.
//

import Foundation

final class SearchViewModel {
    // MARK: - Properties

    private(set) var request = NewsRequest(pageSize: Constants.API.articlesPerPage, page: 1)
    private(set) var hasMoreArticles = true
    private var articles: [Article] = []
    private var sources = [Source]()
    private var isFetchingMore = false
    private let networkManager: NetworkManagerProtocol
    private let realmManager: RealmManagerProtocol

    private var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }

    var numberOfArticles: Int {
        hasMoreArticles ? articles.count + 1 : articles.count
    }

    // MARK: - Initialization

    init(networkManager: NetworkManagerProtocol, realmManager: RealmManagerProtocol) {
        self.networkManager = networkManager
        self.realmManager = realmManager
    }

    // MARK: - Callbacks

    var onArticlesUpdated: (() -> Void)?
    var onArticlesAdded: (() -> Void)?
    var onErrorOccurred: ((String?) -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?

    // MARK: - Modeling methods

    func getCellViewModel(forIndex index: Int) -> ArticleCellViewModel? {
        guard let article = articles.safeElement(at: index) else { return nil }
        return ArticleCellViewModel(from: article, realmManager: realmManager)
    }

    func getWebViewModel(forIndex index: Int) -> WebViewModel? {
        guard let article = articles.safeElement(at: index) else { return nil }
        return WebViewModel(article: article, realmManager: realmManager)
    }

    func fetchNews(withRequest request: NewsRequest) {
        self.request = request
        hasMoreArticles = true
        fetchNews()
    }

    func fetchNews(withQuery query: String?) {
        guard let query else { return }
        if query.replacingOccurrences(of: " ", with: "").isEmpty {
            request.searchQuery = "a"
        } else {
            request.searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        }
        hasMoreArticles = true
        fetchNews()
    }

    func refreshNews() {
        hasMoreArticles = true
        fetchNews()
    }

    // TODO: Bugfix & Refactor

    func fetchNews() {
        articles = []
        request.page = 1
        guard !isLoading else { return }
        isLoading = true
        networkManager.fetchNews(with: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(newsResponse):
                if let fetchedArticles = newsResponse.articles, !fetchedArticles.isEmpty {
                    self.articles = fetchedArticles
                } else {
                    self.onErrorOccurred?(UserError.noSearchResults.userLocalizedDescription)
                    self.hasMoreArticles = false
                }
                if let totalResults = newsResponse.totalResults {
                    self.hasMoreArticles = self.articles.count < totalResults
                }
                self.isLoading = false
                self.onArticlesUpdated?()
            case let .failure(error):
                self.isLoading = false
                self.onErrorOccurred?(error.userLocalizedDescription ?? error.localizedDescription)
            }
        }
    }

    // TODO: Bugfix & Refactor

    func fetchMoreNewsIfNeeded() {
        guard !articles.isEmpty, !isLoading, hasMoreArticles, !isFetchingMore else { return }
        request.page += 1
        isLoading = true
        isFetchingMore = true
        networkManager.fetchNews(with: request) { [weak self] result in
            guard let self else { return }
            self.isFetchingMore = false
            switch result {
            case let .success(newsResponse):
                if let fetchedArticles = newsResponse.articles, !fetchedArticles.isEmpty {
                    let uniqueArticles = fetchedArticles.filter { fetchedArticle in
                        !self.articles.contains { $0.url == fetchedArticle.url }
                    }
                    self.articles += uniqueArticles
                } else {
                    self.hasMoreArticles = false
                }
                if let totalResults = newsResponse.totalResults {
                    self.hasMoreArticles = self.articles.count < totalResults
                }
                self.isLoading = false
                self.onArticlesAdded?()
            case let .failure(error):
                self.isLoading = false
                self.onErrorOccurred?(error.userLocalizedDescription ?? error.localizedDescription)
            }
        }
    }

    func fetchSources(completion: @escaping ([Source]?, UserError?) -> Void) {
        networkManager.fetchSources { result in
            switch result {
            case let .success(sourcesResponse):
                self.sources = sourcesResponse
                completion(self.sources, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}
