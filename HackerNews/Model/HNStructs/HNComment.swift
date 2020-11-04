//
//  HNComment.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 02.11.2020.
//

import Foundation

struct HNComment: Codable {
    let id: Int
    let parent_id: Int?
    let text: String?
    let author: String?
    let children: [HNComment]
}
