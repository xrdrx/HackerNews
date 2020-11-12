//
//  CommentsDisplayModel.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 10.11.2020.
//

import Foundation
import UIKit

protocol CommentDisplayModelDelegate: class {
    func didUpdateItems()
}

class CommentDisplayModel {
    
    weak var delegate: CommentDisplayModelDelegate?
    
    var itemsArray = [CommentForDisplay]()
    var parentId: Int?
    
    var itemsToProcess = 0
    var processedItems = 0
    
    let progressUpdateQueue = DispatchQueue(label: "com.progressUpdate")
    let dataSourceUpdateQueue = DispatchQueue(label: "com.sourceUpdate", qos: .userInitiated)

    let queryConstructor: HNQueryConstructor
    let downloadOperationQueue: OperationQueue
    let downloadSession = URLSession(configuration: .ephemeral)
    
    init() {
        self.queryConstructor = HNQueryConstructor()
        self.downloadOperationQueue = OperationQueue()
    }
    
    func getComments(parentId id: Int) {
        let url = queryConstructor.getUrlFor(id)
        let download = DownloadAndDecode(HNItem.self, from: url, session: downloadSession)
        download.completionHandler = { result in
            switch result {
            case .success(let item):
                self.itemsArray.append(self.createCommentForDisplay(from: item, forLevel: -1))
                if let kids = item.kids {
                    self.parseListOfComments(withIds: kids, level: 0)
                }
            case .failure(let e):
                print(e)
            }
        }
        downloadOperationQueue.addOperation(download)
    }
    
    func parseListOfComments(withIds id: [Int], level: Int) {
        
        progressUpdateQueue.sync {
            itemsToProcess += id.count
        }
        
        id.forEach { (id) in
            let url = queryConstructor.getUrlFor(id)
            let download = DownloadAndDecode(HNItem.self, from: url, session: downloadSession)
            download.completionHandler = { result in
                
                self.progressUpdateQueue.sync {
                    self.processedItems += 1
                    self.updateUiIfNeeded()
                }
                
                switch result {
                case .success(let item):
                    
                    self.dataSourceUpdateQueue.sync {
                        self.appendItemToArray(item)
                    }
                    
                    if let kids = item.kids {
                        self.parseListOfComments(withIds: kids, level: level + 1)
                    }
                    
                case .failure(let e):
                    print(e)
                }
            }
            downloadOperationQueue.addOperation(download)
        }
    }
    
    func updateUiIfNeeded() {
        if self.itemsToProcess == self.processedItems || self.processedItems % 30 == 0 {
            self.delegate?.didUpdateItems()
        }
    }
    
    func appendItemToArray(_ item: HNItem) {
        guard let parentId = item.parent else { return }
        guard let parentIndex = getIndexFor(parentId) else { return }
        let parent = itemsArray[parentIndex]
        guard let itemChildIndex = parent.kids?.firstIndex(of: item.id) else { return }
        
        let finalIndex = getFinalIndex(parent, parentIndex, itemChildIndex)
        let comment = createCommentForDisplay(from: item, forLevel: parent.level + 1)
        expandArrayIfNeeded(&itemsArray, index: finalIndex, defaultItem: CommentForDisplay.empty)
        itemsArray.insert(comment, at: finalIndex)
        
    }
    
    func getIndexFor(_ id: Int) -> Int? {
        return itemsArray.firstIndex { $0.id == id }
    }
    
    func getFinalIndex(_ parent: CommentForDisplay, _ parentIndex: Int, _ itemChildIndex: Int) -> Int{
        if itemChildIndex == 0 { return (parentIndex + 1) }
        if parentIndex == (itemsArray.count - 1) { return (parentIndex + 1) }
        
        var result = parentIndex + itemChildIndex + 1
        let kidsBefore = parent.kids![0..<itemChildIndex]
        let itemsBefore = itemsArray[(parentIndex + 1)...min(parentIndex + itemChildIndex, itemsArray.count - 1)]
        itemsBefore.forEach {
            if !kidsBefore.contains($0.id) { result -= 1 }
        }
        return result
    }
    
    func expandArrayIfNeeded<T>(_ array: inout [T], index: Int, defaultItem: T) {
        let count = array.count
        if count < index + 1 {
            array.append(contentsOf: repeatElement(defaultItem, count: count.distance(to: index)))
        }
    }
    
    func createCommentForDisplay(from item: HNItem, forLevel level: Int) -> CommentForDisplay {
        var attrText: NSMutableAttributedString
        if let text = item.text {
            attrText = createAttributedText(fromString: text)
        } else {
            attrText = NSMutableAttributedString(string: "")
        }
        
        return CommentForDisplay(id: item.id,
                                 text: attrText,
                                 author: item.by ?? "",
                                 parent: item.parent,
                                 kids: item.kids,
                                 level: level,
                                 color: UIColor.black)
    }
    
    private func createAttributedText(fromString string: String) -> NSMutableAttributedString {
        let font = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(15)\">%@</span>", string)

        let attrText = try! NSMutableAttributedString(
            data: font.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        if let lastCharacter = attrText.string.last, lastCharacter == "\n" {
            attrText.deleteCharacters(in: NSRange(location:(attrText.length) - 1, length: 1))
        }
        return attrText
    }
    
    func configureCell(_ cell: CommentTableViewCell, forRowAt row: Int) {
        let comment = itemsArray[row]
        cell.titleLabel.text = comment.author
        cell.contentLabel.attributedText = comment.text
        
        let level = comment.level
        cell.paddingViewWidth.constant = CGFloat(level * 10 + 10)
        if level == 0 {
            cell.leadingLine.isHidden = true
        } else {
            cell.leadingLine.isHidden = false
            cell.leadingLine.backgroundColor = comment.color
        }
    }
}
