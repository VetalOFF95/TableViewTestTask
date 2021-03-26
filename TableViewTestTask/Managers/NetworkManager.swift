//
//  NetworkManager.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 25.03.2021.
//

import Foundation

class NetworkManager {
    
    private init() {}
    static let shared = NetworkManager()
    
    // add your apiKey !!!
    private let apiKey = ""
    private var keyword = ""
    
    private var newsURL: String {
        get {
            return "https://newsapi.org/v2/everything?q=\(keyword)&from=2021-03-25&sortBy=publishedAt&apiKey=\(apiKey)"
        }
    }
    
    public func fetchNewsData(with keyword: String, completion: @escaping (NewsData?) -> ()) {
        self.keyword = keyword
        guard let url = URL(string: newsURL) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, _, error) in
            
            guard let safeData = data,
                  error == nil else {
                completion(nil)
                return
            }
            let newsData = self.parseJSON(safeData)
            completion(newsData)
        }
        task.resume()
    }
    
    private func parseJSON(_ data: Data) -> NewsData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsData.self, from: data)
            return decodedData
        } catch let error  {
            print(error)
            return nil
        }
    }
    
    public func getKeyword() -> String {
        return keyword
    }
}
