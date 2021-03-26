//
//  NewsData.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 25.03.2021.
//

import Foundation

struct NewsData: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String
    let urlToImage: String?
    let url: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
