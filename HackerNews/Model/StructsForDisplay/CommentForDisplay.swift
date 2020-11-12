//
//  CommentForDisplay.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 04.11.2020.
//

import Foundation
import UIKit

struct CommentForDisplay {
    let id: Int
    let text: NSAttributedString
    let author: String
    let parent: Int?
    let kids: [Int]?
    let level: Int
    let color: UIColor
}

extension CommentForDisplay {
    static var empty: CommentForDisplay {
        return CommentForDisplay(id: 0, text: NSAttributedString(string: ""), author: "", parent: nil, kids: nil, level: 0, color: UIColor.black)
    }
}
