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
    
    public func setFilter(_ filter: FilterModel){
        NetworkManager.shared.setFilter(filter)
    }
    
    public func setKeyword(_ keyword: String) {
        NetworkManager.shared.setKeyword(keyword)
    }
    
    public func fetchNews(isFirstPage: Bool, completion: @escaping (Bool) -> ()) {
        
        if isFirstPage {
            NetworkManager.shared.setPageToFirst()
        } else {
            NetworkManager.shared.increacePage()
        }
        
        NetworkManager.shared.fetchNewsData { [weak self] data in
            guard let data = data else {
                completion(false)
                return
            }
            
            if isFirstPage {
                self?.newsItems = []
            }
            
            for item in data.articles {
                let newsItemModel = NewsModel(id: item.source.id,
                                              name: item.source.name,
                                              author: item.author ?? "Unknown author",
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
