//
//  HNQueryConstructor.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 03.11.2020.
//

import Foundation

struct HNQueryConstructor {
    let base = "https://hacker-news.firebaseio.com/v0/"
    let json = ".json"
    
    func getDefaultUrl(forTab tab: HomeTab) -> URL {
        let tab = tab.rawValue
        
        return URL(string: base + tab + json)!
    }
    
    func getUrlFor(_ id: Int) -> URL {
        return URL(string: base + "item/\(id)" + json)!
    }
}

enum HomeTab: String {
    case topstories = "topstories"
    case newstories = "newstories"
    case beststories = "beststories"
    case askstories = "askstories"
    case showstories = "showstories"
    case jobstories = "jobstories"
}
