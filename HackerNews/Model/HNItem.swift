//
//  HNItem.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 29.10.2020.
//

import Foundation

struct HNItem: Codable {
    let id: Int
    let type: String
    let text: String?
}
