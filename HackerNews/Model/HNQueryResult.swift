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
    let title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case title, url
    }
}
