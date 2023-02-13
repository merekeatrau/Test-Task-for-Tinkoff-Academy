//
//  CacheManager.swift
//  IntroLab
//
//  Created by Mereke on 05.02.2023.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let documentDir: URL
    private var articlesFilePath: URL {
        get {
            return documentDir.appending(path: "articles.json")
        }
    }
    
    init() {
        let fileManager = FileManager.default
        do {
            self.documentDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
        } catch {
            print("Error while constructing file path: \(error)")
            self.documentDir = URL(fileURLWithPath: "")
        }
    }
    
    func getAll() -> [Article] {
        do {
            let fileData = try Data(contentsOf: articlesFilePath)
            let decoder = JSONDecoder()
            let articlesEntity = try decoder.decode(ArticlesEntity.self, from: fileData)
            return articlesEntity.articles
        } catch {
            print("Error loading articles: \(error)")
            return []
        }
    }
    
    func addArticles(_ newArticles: [Article]) {
        do {
            let encoder = JSONEncoder()
            let articlesEntity = ArticlesEntity(articles: newArticles)
            let data = try encoder.encode(articlesEntity)
            try data.write(to: articlesFilePath)
        } catch {
            print("Error saving articles: \(error)")
        }
    }
    
    func addImage(_ imageURL: String, data: Data){
        let imagePath = documentDir.appending(path: getImageFileName(path: imageURL))
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: imagePath.path(percentEncoded: false)) {
                try data.write(to: imagePath)
                
            } else {
                fileManager.createFile(atPath: imagePath.path(percentEncoded: false), contents:data)
            }
        }  catch let error {
            print("Error saving image \(getImageFileName(path: imageURL)): \(error)")
        }
    }
    
    func getImage(path: String)-> Data? {
        do {
            let fileData = try Data(contentsOf: documentDir.appending(path: getImageFileName(path: path)))
            return fileData
        } catch let error {
            print("Error loading saved image \(path): \(error)")
            return nil
        }
    }
    
    private func getImageFileName(path: String) -> String {
        path.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
}


