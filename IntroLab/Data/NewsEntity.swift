//
//  NewsEntity.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import Foundation

struct Article: Codable {
    let title: String
    let description: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: Source
}

struct ArticlesEntity: Codable {
    let articles: [Article]
}

struct Source: Codable {
    let id: String?
    let name: String?
}

