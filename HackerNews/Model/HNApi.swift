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

class HNApi {
    
    weak var delegate: HNApiDelegate?
    
    var lastPageNumber: Int?
    var maxNumberOfPages = 50
    
    var itemsForDisplay = [HNHit]()
    
    let downloadingOperations = OperationQueue()
    
    func downloadFirstPage() {
        downloadPage(number: 0)
    }
    
    func downloadNextPage() {
        guard let lastPage = lastPageNumber else { return }
        guard lastPage != (maxNumberOfPages - 1) else { return }
        downloadPage(number: lastPage + 1)
    }
    
    func downloadPage(number page: Int) {
        print("downloading page \(page)")
        let download = SearchRequest(forPageNumber: page)
        download.completionHandler = { (result) in
            switch result {
            case .success(let qResult):
                self.updateState(with: qResult)
            default:
                break
            }
        }
        downloadingOperations.addOperation(download)
    }
    
    func updateState(with page: HNQueryResult) {
        itemsForDisplay.append(contentsOf: page.hits)
        lastPageNumber = page.page
        maxNumberOfPages = page.nbPages
        delegate?.didGetItems()
    }
    
    func getNumberOfRows() -> Int {
        return itemsForDisplay.count
    }
    
    func configureCellAt(_ cell: TitleItemTableViewCell, at indexPath: IndexPath) {
        let item = itemsForDisplay[indexPath.row]
        cell.titleLabel.text = item.title
        cell.pointsLabel.text = "\(item.points ?? 0) points"
        cell.authorLabel.text = "by \(item.author ?? "")"
        cell.commentsLabel.text = (item.commentsCount != nil) ? "\(item.commentsCount!) comments" : "discuss"
        cell.timeLabel.text = ""
    }
}

class SearchRequest: ConcurrentOperation<HNQueryResult> {
    
    let page: Int
    private var task: URLSessionTask?
    var url: String
    
    init(forPageNumber page: Int) {
        self.page = page
        self.url = "https://hn.algolia.com/api/v1/search?tags=front_page&page="
    }
    
    override func main() {
        let url = URL(string: "\(self.url)\(page)")!
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
            if let item = try? JSONDecoder().decode(HNQueryResult.self, from: data) {
                DispatchQueue.main.async {
                    self.complete(result: .success(item))
                }
            }
            self.finish()
        }
    }
}


