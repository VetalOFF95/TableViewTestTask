//
//  NewsVM.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 25.03.2021.
//

import Foundation

class NewsVM {
    private var newsItems = [NewsModel]()
    
    public func getNewsCount() -> Int {
        return newsItems.count
    }
    
    public func getNewsItem(for indexPath: IndexPath) -> NewsModel {
        return newsItems[indexPath.row]
    }
    
    public func fetchNews(with keyword: String, completion: @escaping (Bool) -> ()) {
        newsItems = []
        NetworkManager.shared.fetchNewsData(with: keyword) { [weak self] data in
            guard let data = data else {
                completion(false)
                return
            }
            
            for item in data.articles {
                let newsItemModel = NewsModel(id: item.source.id,
                                              name: item.source.name,
                                              author: item.author ?? "No author",
                                              title: item.title,
                                              description: item.description.replacingOccurrences(of: "\n", with: " "),
                                              urlToImage: item.urlToImage ?? "No url to image",
                                              url: item.url)
                self?.newsItems.append(newsItemModel)
            }
            completion(true)
        }
    }
    
    public func getNewsItemUrl(for indexPath: IndexPath) -> URL? {
        let newsItem = getNewsItem(for: indexPath)
        guard let url = URL(string: newsItem.url) else {
            return nil
        }
        return url
    }
}
