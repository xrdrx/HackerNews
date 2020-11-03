//
//  Constants.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 02.11.2020.
//

import Foundation

enum C {
    static let TVCell = "Cell"
    
    enum Cells {
        static let titleItemCellId = "titleItemCell"
        static let titleItemCellName = "TitleItemTableViewCell"
        static let commentCellName = "CommentTableViewCell"
        static let commentCellId = "commentCell"
    }
    
    enum Segues {
        static let commentsSegue = "presentComments"
    }
    
    enum Colors {
        static let hnOrange = "HNOrange"
    }
    
    enum Storyboards {
        static let front = "frontPage"
        static let latest = "latestStory"
    }
}
