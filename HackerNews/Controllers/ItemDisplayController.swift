//
//  ItemDisplayController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 05.11.2020.
//

import UIKit

class ItemDisplayController: UITableViewController {

    var model: ItemDisplayModel
    
    required init?(coder: NSCoder) {
        self.model = ItemDisplayModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: C.Cells.titleItemCellName, bundle: nil), forCellReuseIdentifier: C.Cells.titleItemCellId)
        
        tableView.prefetchDataSource = self
        
        tableView.rowHeight = 75
        
        model.fetchItemIdList()
        model.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CommentsViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        destination.itemId = model.getItemId(forItemAt: indexPath)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Cells.titleItemCellId, for: indexPath) as! TitleItemTableViewCell
        
        model.configureCell(cell, forRowAt: indexPath)
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: C.Segues.commentsSegue, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        model.cancelFetching(for: indexPath)
    }
}

//MARK: - Item display model delegate

extension ItemDisplayController: ItemDisplayModelDelegate {
    func didUpdateItemIdList() {
        tableView.reloadData()
    }
    
    func didGetNewItem(for indexPath: IndexPath) {
        guard let visibleRows = tableView.indexPathsForVisibleRows else { return }
        if visibleRows.contains(indexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! TitleItemTableViewCell
            model.configureCell(cell, forRowAt: indexPath)
        }
    }
}

//MARK: - Table view data source prefetching

extension ItemDisplayController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { model.fetchItem(for: $0) }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { model.cancelFetching(for: $0) }
    }
}
