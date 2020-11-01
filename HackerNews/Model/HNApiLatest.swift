//
//  HNApiLatest.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 01.11.2020.
//

import Foundation

class HNApiLatest: HNApi {
    override func downloadPage(number page: Int) {
        print("downloading page \(page)")
        let download = SearchRequestLatest(forPageNumber: page)
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

}
