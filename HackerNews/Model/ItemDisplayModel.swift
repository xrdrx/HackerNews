//
//  ItemDisplayModel.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 05.11.2020.
//

import Foundation
import UIKit

protocol ItemDisplayModelDelegate: class {
    func didUpdateItemIdList()
    func didGetNewItem(for indexPath: IndexPath)
}

class ItemDisplayModel {
    
    weak var delegate: ItemDisplayModelDelegate?
    
    var items = [IndexPath: HNItem]()
    var itemsId = [Int]()
    
    let queryConstructor: HNQueryConstructor
    let downloadOperationQueue: OperationQueue
    let downloadSession = URLSession(configuration: .ephemeral)
    var downloadingOperations = [IndexPath: DownloadAndDecode<HNItem>]()
    
    init() {
        self.queryConstructor = HNQueryConstructor()
        self.downloadOperationQueue = OperationQueue()
    }
    
    func fetchItemIdList() {
        let url = queryConstructor.getDefaultUrl(forTab: .topstories)
        let download = DownloadAndDecode(HNItemIdList.self, from: url, session: downloadSession)
        download.completionHandler = { result in
            switch result {
            case .success(let list):
                self.itemsId = list
                self.delegate?.didUpdateItemIdList()
            case .failure(let e):
                print(e)
            }
        }
        downloadOperationQueue.addOperation(download)
    }
    
    func numberOfRowsInSection() -> Int{
        return itemsId.count
    }
    
    func configureCell(_ cell: TitleItemTableViewCell, forRowAt indexPath: IndexPath) {
        if let item = items[indexPath] {
            configureCell(cell, with: item)
        } else {
            clearCell(cell)
            fetchItem(for: indexPath)
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
        cell.titleLabel.text = "Loading..."
        cell.pointsLabel.text = " "
        cell.authorLabel.text = " "
        cell.commentsLabel.text = " "
        cell.timeLabel.text = " "
    }
    
    func fetchItem(for indexPath: IndexPath) {
        guard downloadingOperations[indexPath] == nil else { return }
        guard items[indexPath] == nil else { return }
        let id = getItemId(forItemAt: indexPath)
        let url = queryConstructor.getUrlFor(id)
        let download = DownloadAndDecode(HNItem.self, from: url, session: downloadSession)
        download.completionHandler = { result in
            self.downloadingOperations[indexPath] = nil
            switch result {
            case .success(let item):
                self.items[indexPath] = item
                self.delegate?.didGetNewItem(for: indexPath)
            default:
                return
            }
        }
        downloadOperationQueue.addOperation(download)
        downloadingOperations[indexPath] = download
    }
    
    func cancelFetching(for indexPath: IndexPath) {
        guard let operation = downloadingOperations[indexPath] else { return }
        operation.cancel()
        downloadingOperations[indexPath] = nil
    }
    
    func getItemId(forItemAt indexPath: IndexPath) -> Int {
        return itemsId[indexPath.row]
    }
}
