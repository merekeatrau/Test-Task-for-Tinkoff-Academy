//
//  NewsEntity.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import Foundation

struct Article: Decodable {
    let title: String
    let description: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: Source
}

struct ArticlesEntity: Decodable {
    let articles: [Article]
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
