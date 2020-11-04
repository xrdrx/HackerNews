//
//  HNQueryConstructor.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 03.11.2020.
//

import Foundation

struct HNQueryConstructor {
    
    func getDefaultUrl(forTab tab: HomeTab, pageNumber page: Int) -> URL{
        switch tab {
        case .front:
            return URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page&page=\(page)")!
        case .latest:
            return URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(page)")!
        }
    }
    
    func getCommentsUrl(forId id: Int) -> URL{
        return URL(string: "https://hn.algolia.com/api/v1/items/\(id)")!
    }
}

enum HomeTab {
    case front
    case latest
}
