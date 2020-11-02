//
//  QueryResults.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 30.10.2020.
//

import Foundation

struct HNQueryResult: Codable {
    let hits: [HNHit]
    let page: Int
    let nbPages: Int
}

struct HNHit: Codable {
    let id: String
    let commentsCount: Int?
    let title: String?
    let points: Int?
    let author: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case commentsCount = "num_comments"
        case title, points, author
    }
}
