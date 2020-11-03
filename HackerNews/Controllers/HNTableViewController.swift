//
//  HNTableViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 29.10.2020.
//

import UIKit

class HNTableViewController: UITableViewController {
    
    var api: HNApi
    
    required init?(coder: NSCoder) {
        api = HNApi(homeTab: .front)
        
        super.init(coder: coder)
        
        api.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: C.Cells.titleItemCellName, bundle: nil), forCellReuseIdentifier: C.Cells.titleItemCellId)
        
        api.downloadFirstPage()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CommentsViewController else { return }
        guard let row = selectedRow() else { return }
        destination.itemId = api.getItemIdForSelected(row: row)
    }
    
    private func selectedRow() -> Int? {
        return tableView.indexPathForSelectedRow?.row
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return api.getNumberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Cells.titleItemCellId, for: indexPath) as! TitleItemTableViewCell
        
        api.configureCell(cell, at: indexPath)
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        api.willDisplayCell(forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: C.Segues.commentsSegue, sender: self)
    }
}

//MARK: - HNApi delegate

extension HNTableViewController: HNApiDelegate {
    
    func didGetItems() {
        reloadTableView()
    }
}
