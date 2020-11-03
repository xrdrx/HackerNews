//
//  HNLatestStoryTableViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 01.11.2020.
//

import Foundation
import UIKit

class HNLatestStoryTableViewController: HNTableViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        api = HNApi(homeTab: .latest)
        api.delegate = self
    }
}
