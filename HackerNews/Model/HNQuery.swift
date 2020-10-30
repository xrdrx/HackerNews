//
//  QueryResults.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 30.10.2020.
//

import Foundation

struct HNQuery: Codable {
    let hits: [HNHits]
}

struct HNHits: Codable {
    let id: String
    let title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case title, url
    }
}
