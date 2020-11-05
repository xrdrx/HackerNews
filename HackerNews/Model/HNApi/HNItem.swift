//
//  HNItem.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 05.11.2020.
//

import Foundation

struct HNItem: Codable {
    let id: Int
    let by: String?
    let title: String?
    let descendants: Int?
    let score: Int?
}
