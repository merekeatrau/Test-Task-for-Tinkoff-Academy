//
//  APIClient.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import Foundation

class APIClient {
    
    private let API_KEY = "6ac0be01a12c4e3bb460346b56b84349"
    
    static var shared = APIClient()
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "apiKey", value: API_KEY)
        ]
        return components
    }()
    
    private let session: URLSession
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func loadArticles(completion: @escaping ([Article]) -> Void) {
        var components = urlComponents
        components.path = "/v2/top-headlines"
        
        guard let requestUrl = components.url else {
            return
        }
        print("requestUrl \(requestUrl)" )
        let task = session.dataTask(with: requestUrl) { data, response , error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Didnt receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            do {
                let articlesEntity = try JSONDecoder().decode(ArticlesEntity.self, from: data)
                DispatchQueue.main.async {
                    completion(articlesEntity.articles)
                }
                
            }  catch let decodingError as DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key not found: \(key) in context \(context)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch: \(type) in context \(context)")
                case .valueNotFound(let type, let context):
                    print("Value not found: \(type) in context \(context)")
                default:
                    print("Error during decoding: \(decodingError)")
                }
                DispatchQueue.main.async  {
                    completion([])
                }
            } catch {
                print("Error during decoding: \(error)")
            }
        }
        task.resume()
    }
    
    var imagesCache = NSCache<NSString, NSData>()

    func loadImage(with path: String, completion: @escaping (Data) -> Void) {
        if let imageData = imagesCache.object(forKey: path as NSString) {
            completion(imageData as Data)
            return
        }
        
        guard let url = URL(string: path) else { return }
        let task = session.downloadTask(with: url) { localUrl, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let localUrl = localUrl else {
                print("Error: error calling data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP falling")
                return
            }
            
            do {
                let imageData = try Data(contentsOf: localUrl)
                DispatchQueue.main.async {
                    self.imagesCache.setObject(imageData as NSData, forKey: path as NSString)
                    completion(imageData)
                }
            } catch {
                DispatchQueue.main.async {
                }
            }
        }
        task.resume()
    }
    
}
