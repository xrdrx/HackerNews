//
//  SearchRequestLatest.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 01.11.2020.
//

import Foundation

class SearchRequestLatest: SearchRequest {
    
    override init(forPageNumber page: Int) {
        super.init(forPageNumber: page)
        self.url = "https://hn.algolia.com/api/v1/search_by_date?tags=story&page="
    }
}
