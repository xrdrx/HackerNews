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
        tableView.prefetchDataSource = self
        api.getMaxItemId()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return api.getNumberOfRows()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.TVCell, for: indexPath)
        
        api.configureCellAt(cell, at: indexPath)
        if indexPath.row == (api.numberOfRows - 30) {
            api.incrementNumberOfRowsBy(30)
            tableView.reloadData()
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operation = api.pendingOperations[indexPath] {
            operation.cancel()
            api.pendingOperations[indexPath] = nil
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Table view data source prefetching

extension HNTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let cell = tableView.dequeueReusableCell(withIdentifier: C.TVCell, for: indexPath)
            api.downloadItem(for: cell, at: indexPath)
        }
    }
}

//MARK: - HNApi delegate

extension HNTableViewController: HNApiDelegate {
    
    func didGetItems() {
        reloadTableView()
    }
}
