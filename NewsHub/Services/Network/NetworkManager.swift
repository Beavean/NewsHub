//
//  NetworkManager.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchNews(with request: NewsRequest, completion: @escaping (Result<NewsResponse, UserError>) -> Void)
    func fetchSources(completion: @escaping (Result<[Source], UserError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let networkConnectionCheckUrl = Constants.API.baseUrl
    private let headlinesUrl = Constants.API.headLines
    private let sourcesURL = Constants.API.sources
    private let apiKey = Constants.API.apiKey

    func fetchNews(with request: NewsRequest, completion: @escaping (Result<NewsResponse, UserError>) -> Void) {
        checkInternetConnection { [self] isConnected in
            guard isConnected else {
                completion(.failure(.noConnection))
                return
            }
            var components = URLComponents(string: headlinesUrl)!
            var queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            queryItems.append(contentsOf: request.queryItems)
            components.queryItems = queryItems
            let urlRequest = URLRequest(url: components.url!)
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                            completion(.success(newsResponse))
                        } catch {
                            print("debugError: \(error)")
                            completion(.failure(.noSearchResults))
                        }
                    } else if let error {
                        print("debugError: \(error)")
                        completion(.failure(.serverError))
                    }
                }
            }.resume()
        }
    }

    func fetchSources(completion: @escaping (Result<[Source], UserError>) -> Void) {
        checkInternetConnection { [self] isConnected in
            guard isConnected else {
                completion(.failure(.noConnection))
                return
            }
            var components = URLComponents(string: sourcesURL)!
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            let urlRequest = URLRequest(url: components.url!)
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let sourcesResponse = try JSONDecoder().decode(SourcesResponse.self, from: data)
                            completion(.success(sourcesResponse.sources))
                        } catch {
                            completion(.failure(.serverError))
                        }
                    } else if let error {
                        print("debugError: \(error)")
                        completion(.failure(.serverError))
                    }
                }
            }.resume()
        }
    }

    private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: networkConnectionCheckUrl) else {
            completion(false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
}
