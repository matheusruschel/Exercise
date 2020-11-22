//
//  Networking.swift
//  Exercise
//
//  Created by Matheus Ruschel on 2020-11-21.
//

import Foundation

public let hackerNewsBaseUrl: String = "https://hacker-news.firebaseio.com/v0"

enum NetworkingError: Error {
    case incorrectUrl
    case unknownError
    case jsonParsingError
}

typealias APIResultCompletion<T> = (Result<T, NetworkingError>) -> Void

class Networking {
    
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    private func fetchTopStoryIds(completion: @escaping APIResultCompletion<[Int]>) {
        
        let urlString = baseUrl + "/topstories.json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.incorrectUrl))
            return
        }
        
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if error != nil {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let json = try JSONDecoder().decode([Int].self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(.jsonParsingError))
            }
        
        } )
        task.resume()
    }
    
    func fetchNews(completion: @escaping APIResultCompletion<[News]>) {
        fetchTopStoryIds(completion: { result in
            
            
            switch result {
            case .success(let object):
                
                let session = URLSession.shared
                let dispatchGroup = DispatchGroup()
                var newsArray = [News]()
                for id in object {
                    
                    
                    let urlString = self.baseUrl + "/item/\(id).json"
                    
                    guard let url = URL(string: urlString) else {
                        completion(.failure(NetworkingError.incorrectUrl))
                        return
                    }
                    
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "GET"
                    
                    dispatchGroup.enter()
                    let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
                        dispatchGroup.leave()
                        if error != nil {
                            completion(.failure(.unknownError))
                            return
                        }
                        
                        guard let data = data else {
                            completion(.failure(.unknownError))
                            return
                        }
                        
                        if let news = try? JSONDecoder().decode(News.self, from: data) {
                            newsArray.append(news)
                        }
                        
                    
                    } )
                    task.resume()
                }
                
                dispatchGroup.notify(queue: DispatchQueue.global()) {
                  completion(.success(newsArray))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
            
        })
        
    }
    
}
