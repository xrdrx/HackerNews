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
    
    let queryConstructor = HNQueryConstructor()
    
    var itemsForDisplay = [HNHit]()
    
    let downloadingOperations = OperationQueue()
    
    init(homeTab: HomeTab) {
        self.homeTab = homeTab
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
        print("downloading page \(page)")
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

struct HNQueryConstructor {
    
    func getDefaultUrl(forTab tab: HomeTab, pageNumber page: Int) -> URL{
        switch tab {
        case .front:
            return URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page&page=\(page)")!
        case .latest:
            return URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(page)")!
        }
    }
}

enum HomeTab {
    case front
    case latest
}

