//
//  HNTableViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 29.10.2020.
//

import UIKit

class HNTableViewController: UITableViewController {
    
    let api: HNApi
    
    required init?(coder: NSCoder) {
        api = HNApi()
        
        super.init(coder: coder)
        
        api.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.downloadFirstPage()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return api.getNumberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.TVCell, for: indexPath)
        
        api.configureCellAt(cell, at: indexPath)
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (api.getNumberOfRows() - 10) {
            api.downloadNextPage()
        }
    }
}

//MARK: - HNApi delegate

extension HNTableViewController: HNApiDelegate {
    
    func didGetItems() {
        reloadTableView()
    }
}
