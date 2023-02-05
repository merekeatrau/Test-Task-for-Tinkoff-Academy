//
//  ArticleRepository.swift
//  IntroLab
//
//  Created by Mereke on 05.02.2023.
//

import Foundation

class ArticleRepository {
    static let shared = ArticleRepository()
    
    private let cacheManager = CacheManager.shared
    private let apiClient = APIClient.shared
    
    func getArticles(completion: @escaping ([Article]) -> Void) {
        let cachedArticles = cacheManager.getAll()
        if !cachedArticles.isEmpty {
            completion(cachedArticles)
        }
        
        apiClient.loadArticles { [weak self] articles in
            self?.cacheManager.addArticles(articles)
            completion(articles)
        }
    }
    
    func loadImage(path: String, completion: @escaping (Data) -> Void) {
        let cachedImage = cacheManager.getImage(path: path)
        if let cachedImage = cachedImage {
            completion(cachedImage)
        }
        
        apiClient.loadImage(with: path) { [weak self] data in
            self?.cacheManager.addImage(path, data: data)
            completion(data)
        }
    }
}

