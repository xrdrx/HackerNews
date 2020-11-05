//
//  HNQueryConstructor.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 03.11.2020.
//

import Foundation

struct HNQueryConstructor {
    
    func getDefaultUrl(forTab tab: HomeTab, pageNumber page: Int) -> URL {
        switch tab {
        case .latest:
            return URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(page)")!
        default:
            return URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page&page=\(page)")!
        }
    }
    
    func getDefaultUrl(forTab tab: HomeTab) -> URL {
        switch tab {
        case .topstories:
            return URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json")!
        default:
            return URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json")!
        }
    }
    
    func getCommentsUrl(forId id: Int) -> URL {
        return URL(string: "https://hn.algolia.com/api/v1/items/\(id)")!
    }
    
    func getUrlFor(_ id: Int) -> URL {
        return URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
    }
}

enum HomeTab {
    case front
    case latest
    case topstories
    case newstories
    case beststories
    case askstories
    case showstories
    case jobstories
}
