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
    
    private var items: [IndexPath: HNItem] = [:]
    private var itemsId: [Int] = []
    private let defaultTab: HomeTab
    
    private let queryConstructor: HNQueryConstructor
    private let downloadOperationQueue: OperationQueue
    private let downloadSession = URLSession(configuration: .ephemeral)
    private var downloadingOperations: [IndexPath: DownloadAndDecode<HNItem>] = [:]
    
    init(defaultTab: HomeTab = .topstories) {
        self.defaultTab = defaultTab
        self.queryConstructor = HNQueryConstructor()
        self.downloadOperationQueue = OperationQueue()
    }
    
    func fetchItemIdList() {
        let url = queryConstructor.getDefaultUrl(forTab: defaultTab)
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
    
    func getNumberOfRowsInSection() -> Int{
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
    
    private func configureCell(_ cell: TitleItemTableViewCell, with item: HNItem) {
        DispatchQueue.main.async {
            cell.titleLabel.text = item.title ?? " "
            cell.pointsLabel.text = "\(item.score ?? 0) points"
            cell.authorLabel.text = "by \(item.by ?? "NaN")"
            cell.commentsLabel.text = "\(item.descendants ?? 0) comments"
            cell.timeLabel.text = ""
        }
    }
    
    private func clearCell(_ cell: TitleItemTableViewCell) {
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
