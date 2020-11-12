//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 10.11.2020.
//

import UIKit

class CommentViewController: UITableViewController {
    
    var model: CommentDisplayModel
    
    var itemId: Int?
    
    required init?(coder: NSCoder) {
        self.model = CommentDisplayModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: C.Cells.commentCellName, bundle: nil), forCellReuseIdentifier: C.Cells.commentCellId)
        
        model.delegate = self
        
        if let id = itemId {
            model.parentId = id
            model.getComments(parentId: id)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Cells.commentCellId, for: indexPath) as! CommentTableViewCell
        
        model.configureCell(cell, forRowAt: indexPath.row)
        
        return cell
    }
}

extension CommentViewController: CommentDisplayModelDelegate {
    
    func didUpdateItems() {
        tableView.reloadData()
    }
}
