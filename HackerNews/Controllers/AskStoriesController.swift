//
//  AskStoriesController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 09.11.2020.
//

import UIKit

class AskStoriesController: ItemDisplayController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.model = ItemDisplayModel(defaultTab: .askstories)
    }
}
