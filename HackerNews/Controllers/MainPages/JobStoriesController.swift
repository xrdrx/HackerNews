//
//  JobStoriesController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 09.11.2020.
//

import UIKit

class JobStoriesController: ItemDisplayController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.model = ItemDisplayModel(defaultTab: .jobstories)
    }
}
