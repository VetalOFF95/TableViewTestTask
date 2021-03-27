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
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
    
    // add your apiKey !!!
    private let apiKey = ""
    
    private var keyword = ""
    private let pageSize = 5
    private var page = 1
    private var date: String {
        get {
            let date = Date()
            return formatter.string(from: date)
        }
    }
    
    private var newsURL: String {
        get {
            return "https://newsapi.org/v2/everything?qInTitle=\(keyword)&from=\(date)&sortBy=publishedAt&pageSize=\(pageSize)&page=\(page)&apiKey=\(apiKey)"
        }
    }
    
    public func setPageToFirst() {
        page = 1
    }
    
    public func increacePage() {
        page += 1
    }
    
    public func fetchNewsData(with keyword: String, completion: @escaping (NewsData?) -> ()) {
        self.keyword = keyword
        guard let url = URL(string: newsURL) else {
            completion(nil)
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
