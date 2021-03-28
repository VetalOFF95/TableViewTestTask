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
    
    private var keyword = ""
    private var category = ""
    private var country = ""
    private var sources = ""
    private let pageSize = 5
    private var page = 1
    
    public func fetchNewsData(completion: @escaping (NewsData?) -> ()) {
        let endpointURL = buildUrl()
        guard let url = URL(string: endpointURL) else {
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
    
    private func buildUrl() -> String {
        var url = ""
        if keyword.isEmpty {
            let urlBuilder = URLBuilder(baseUrl: .topHeadlines)
            if !category.isEmpty {
                urlBuilder.category(category)
            }
            if !country.isEmpty {
                urlBuilder.country(country)
            }
            if !sources.isEmpty {
                urlBuilder.sources(sources)
            }
            urlBuilder.page(page)
            urlBuilder.pageSize(pageSize)
            url = urlBuilder.build()
        } else {
            let urlBuilder = URLBuilder(baseUrl: .everything)
            urlBuilder.keyword(keyword)
            urlBuilder.sortBy()
            urlBuilder.currentDate()
            urlBuilder.page(page)
            urlBuilder.pageSize(pageSize)
            url = urlBuilder.build()
        }
        return url
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
    
    public func setFilter(_ filter: FilterModel) {
        keyword = ""
        category = filter.category ?? ""
        country = filter.country ?? ""
        sources = filter.sources ?? ""
    }
    
    public func setKeyword(_ keyword: String) {
        self.keyword = keyword
        category = ""
        country = ""
        sources = ""
    }
    
    public func getKeyword() -> String {
        return keyword
    }
    
    public func setPageToFirst() {
        page = 1
    }
    
    public func increacePage() {
        page += 1
    }
}
