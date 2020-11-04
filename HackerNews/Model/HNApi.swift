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
    
    var homeTab: HomeTab
    var lastPageNumber: Int?
    var maxNumberOfPages = 50
    
    let queryConstructor: HNQueryConstructor
    let downloadingOperations: OperationQueue
    
    var itemsForDisplay = [HNHit]()
    
    init(homeTab: HomeTab) {
        self.homeTab = homeTab
        self.queryConstructor = HNQueryConstructor()
        self.downloadingOperations = OperationQueue()
    }
    
    func downloadFirstPage() {
        downloadPage(number: 0)
    }
    
    func downloadNextPage() {
        guard let lastPage = lastPageNumber else { return }
        guard lastPage != (maxNumberOfPages - 1) else { return }
        downloadPage(number: lastPage + 1)
    }
    
    func downloadPage(number page: Int) {
        let url = queryConstructor.getDefaultUrl(forTab: homeTab, pageNumber: page)
        let download = DownloadAndDecode(HNQueryResult.self, from: url)
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
    
    func processResult(_ result: Result<HNQueryResult>) {
        
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
    
    func configureCell(_ cell: TitleItemTableViewCell, at indexPath: IndexPath) {
        let item = itemsForDisplay[indexPath.row]
        cell.titleLabel.text = item.title
        cell.pointsLabel.text = "\(item.points ?? 0) points"
        cell.authorLabel.text = "by \(item.author ?? "")"
        cell.commentsLabel.text = (item.commentsCount != nil) ? "\(item.commentsCount!) comments" : "discuss"
        cell.timeLabel.text = ""
    }
    
    func getItemIdForSelected(row: Int) -> Int? {
        return Int(itemsForDisplay[row].id)
    }
    
    func willDisplayCell(forRowAt indexPath: IndexPath) {
        if timeToFetchNewPage(currentRow: indexPath.row) {
            downloadNextPage()
        }
    }
    
    func timeToFetchNewPage(currentRow row: Int) -> Bool {
        return row == itemsForDisplay.count - 15
    }
}
