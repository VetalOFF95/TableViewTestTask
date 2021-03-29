//
//  URLBuilder.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 28.03.2021.
//

import Foundation

enum BaseUrlType {
    case everything
    case topHeadlines
}

class URLBuilder {
    private var url: String
    
    /// add your apiKey !!!
    private let apiKey = ""
    private var baseEverythingURL = "https://newsapi.org/v2/everything"
    private var baseTopHeadlinesURL = "https://newsapi.org/v2/top-headlines"
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
    
    init(baseUrl: BaseUrlType) {
        switch baseUrl {
        case .everything:
            url = "\(baseEverythingURL)?apiKey=\(apiKey)"
        case .topHeadlines:
            url = "\(baseTopHeadlinesURL)?apiKey=\(apiKey)"
        }
    }
    
    public func keyword(_ keyword: String) {
        url = "\(url)&qInTitle=\(keyword)"
    }
    
    public func category(_ category: String) {
        url = "\(url)&category=\(category)"
    }
    
    public func country(_ country: String) {
        url = "\(url)&country=\(country)"
    }
    
    public func sources(_ sources: String) {
        url = "\(url)&sources=\(sources)"
    }
    
    public func currentDate() {
        url = "\(url)&date=\(formatter.string(from: Date()))"
    }
    
    public func pageSize(_ pageSize: Int) {
        url = "\(url)&pageSize=\(pageSize)"
    }
    
    public func page(_ page: Int) {
        url = "\(url)&page=\(page)"
    }
    
    public func sortBy(_ sortBy: String = "publishedAt") {
        url = "\(url)&sortBy=\(sortBy)"
    }
    
    public func build() -> String {
        return url
    }
}


