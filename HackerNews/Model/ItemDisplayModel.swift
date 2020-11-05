//
//  ItemDisplayModel.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 05.11.2020.
//

import Foundation

protocol ItemDisplayModelDelegate: class {
    func didUpdateItemIdList()
    func didGetNewItem(for indexPath: IndexPath)
}

class ItemDisplayModel {
    
    weak var delegate: ItemDisplayModelDelegate?
    
    var items = [IndexPath: HNItem]()
    var itemsId = [Int]()
    
    let queryConstructor: HNQueryConstructor
    let downloadingOperations: OperationQueue
    var pendingOperations = [IndexPath: Operation]()
    
    init() {
        self.queryConstructor = HNQueryConstructor()
        self.downloadingOperations = OperationQueue()
    }
    
    func fetchItemIdList() {
        let url = queryConstructor.getDefaultUrl(forTab: .topstories)
        let download = DownloadAndDecode(HNItemIdList.self, from: url)
        download.completionHandler = { result in
            switch result {
            case .success(let list):
                self.itemsId = list
                self.delegate?.didUpdateItemIdList()
            case .failure(let e):
                print(e)
            }
        }
        downloadingOperations.addOperation(download)
    }
    
    func numberOfRowsInSection() -> Int{
        return itemsId.count
    }
    
    func configureCell(_ cell: TitleItemTableViewCell, forRowAt indexPath: IndexPath) {
        if let item = items[indexPath] {
            configureCell(cell, with: item)
        } else {
            fetchItem(for: cell, at: indexPath)
        }
    }
    
    func configureCell(_ cell: TitleItemTableViewCell, with item: HNItem) {
        DispatchQueue.main.async {
            cell.titleLabel.text = item.title ?? " "
            cell.pointsLabel.text = "\(item.score ?? 0) points"
            cell.authorLabel.text = "by \(item.by ?? "NaN")"
            cell.commentsLabel.text = "\(item.descendants ?? 0) comments"
            cell.timeLabel.text = ""
        }
    }
    
    func clearCell(_ cell: TitleItemTableViewCell) {
        cell.titleLabel.text = " "
        cell.pointsLabel.text = " "
        cell.authorLabel.text = " "
        cell.commentsLabel.text = " "
        cell.timeLabel.text = " "
    }
    
    func fetchItem(for cell: TitleItemTableViewCell, at indexPath: IndexPath) {
        guard pendingOperations[indexPath] == nil else { return }
        let id = getItemId(forItemAt: indexPath)
        let cellId = cell.representedIdentifier
        let url = queryConstructor.getUrlFor(id)
        let download = DownloadAndDecode(HNItem.self, from: url)
        download.completionHandler = { result in
            self.pendingOperations[indexPath] = nil
            switch result {
            case .success(let item):
                self.items[indexPath] = item
                print("Cell id: \(cell.representedIdentifier), \n stored id: \(cellId)")
                if cell.representedIdentifier == cellId {
                    print("cell id match")
                    self.configureCell(cell, with: item)
                }
            default:
                return
            }
        }
        downloadingOperations.addOperation(download)
        pendingOperations[indexPath] = download
        
    }
    
    func fetchItem(for indexPath: IndexPath) {
        guard pendingOperations[indexPath] == nil else { return }
        let id = getItemId(forItemAt: indexPath)
        let url = queryConstructor.getUrlFor(id)
        let download = DownloadAndDecode(HNItem.self, from: url)
        download.completionHandler = { result in
            self.pendingOperations[indexPath] = nil
            switch result {
            case .success(let item):
                self.items[indexPath] = item
                self.delegate?.didGetNewItem(for: indexPath)
            default:
                return
            }
        }
        downloadingOperations.addOperation(download)
        pendingOperations[indexPath] = download
    }
    
    func getItemId(forItemAt indexPath: IndexPath) -> Int {
        return itemsId[indexPath.row]
    }
}
