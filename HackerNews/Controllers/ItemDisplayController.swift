//
//  ItemDisplayController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 05.11.2020.
//

import UIKit

class ItemDisplayController: UITableViewController {

    let model: ItemDisplayModel
    
    required init?(coder: NSCoder) {
        self.model = ItemDisplayModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: C.Cells.titleItemCellName, bundle: nil), forCellReuseIdentifier: C.Cells.titleItemCellId)
        
        tableView.prefetchDataSource = self
        
        model.fetchItemIdList()
        model.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Cells.titleItemCellId, for: indexPath) as! TitleItemTableViewCell
        
        model.clearCell(cell)
        print(indexPath)
        print(cell.representedIdentifier)
        cell.representedIdentifier = UUID()
        print(cell.representedIdentifier)
        
        model.configureCell(cell, forRowAt: indexPath)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ItemDisplayController: ItemDisplayModelDelegate {
    func didUpdateItemIdList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didGetNewItem(for indexPath: IndexPath) {
        guard let visibleRows = tableView.indexPathsForVisibleRows else { return }
        if visibleRows.contains(indexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! TitleItemTableViewCell
            model.configureCell(cell, forRowAt: indexPath)
        }
    }
}

extension ItemDisplayController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { model.fetchItem(for: $0) }
    }
}
