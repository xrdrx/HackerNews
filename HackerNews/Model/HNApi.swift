//
//  HNApi.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 29.10.2020.
//

import Foundation
import UIKit

protocol HNApiDelegate: class {
    func didGetItems()
}

class HNApi: NetworkServiceDelegate {
    
    func didGetItem(_ item: HNItem) {
    }
    
    
    weak var delegate: HNApiDelegate?
    
    let networkService: NetworkService
    
    var maxItemId: Int?
    var numberOfRows = 100
    
    var downloadingOperations = OperationQueue()
    var pendingOperations = [IndexPath: Operation]()
    
    init() {
        networkService = NetworkService(session: URLSession(configuration: .default))
        networkService.delegate = self
    }
    
    func didGetMaxItems(_ items: Int) {
        maxItemId = items
        delegate?.didGetItems()
    }
    
    func getMaxItemId() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/maxitem.json")!
        networkService.getDataFromUrl(url: url, dataType: Int.self)
    }
   
    var downloadedItems = [IndexPath: HNItem]()
    
    func getNumberOfRows() -> Int {
        return numberOfRows
    }
    
    func incrementNumberOfRowsBy(_ number: Int) {
        numberOfRows += number
    }
    
    func configureCellAt(_ cell: UITableViewCell, at indexPath: IndexPath) {
        if let item = downloadedItems[indexPath] {
            configure(cell, with: item)
            return
        }
        configure(cell)
        downloadItem(for: cell, at: indexPath)
    }
    
    func configure(_ cell: UITableViewCell, with item: HNItem? = nil) {
        if let item = item {
            cell.textLabel?.text = String(item.id)
        } else {
            cell.textLabel?.text = ""
        }
    }
    
    func downloadItem(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let id = calculateIdFor(indexPath) else { return }
        if downloadedItems[indexPath] != nil { return }
        let download = DownloadHNItem(with: id)
        download.completionHandler = { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let item):
                    self.downloadedItems[indexPath] = item
                    self.configure(cell, with: item)
                default:
                    break
                }
            }
        }
        downloadingOperations.addOperation(download)
        pendingOperations[indexPath] = download
    }
    
    private func calculateIdFor(_ indexPath: IndexPath) -> Int? {
        if let max = maxItemId { return max - indexPath.row }
        return nil
    }
    
}

class DownloadHNItem: ConcurrentOperation<HNItem> {
    private let id: Int
    private var task: URLSessionTask?
    
    init(with id: Int) {
        self.id = id
    }
    
    override func main() {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: completionHandler(_:_:_:))
        task.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    private func completionHandler(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        if let data = data {
            if let item = try? JSONDecoder().decode(HNItem.self, from: data) {
                DispatchQueue.main.async {
                    self.complete(result: .success(item))
                }
            }
        }
    }
    
    deinit {
        print("Removing operation with id \(id)")
    }
}

class SearchRequest: ConcurrentOperation<HNQuery> {
    
    private let page: Int
    private var task: URLSessionTask?
    
    init(for page: Int) {
        self.page = page
    }
    
    override func main() {
        let url = URL(string: "http://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(page)")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: completionHandler(_:_:_:))
        task.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    private func completionHandler(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        if let data = data {
            if let item = try? JSONDecoder().decode(HNQuery.self, from: data) {
                DispatchQueue.main.async {
                    self.complete(result: .success(item))
                }
            }
        }
    }
}


