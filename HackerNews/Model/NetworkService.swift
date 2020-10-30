//
//  NetworkService.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 29.10.2020.
//

import Foundation
import UIKit

protocol NetworkServiceDelegate: class {
    func didGetMaxItems(_ items: Int)
    func didGetItem(_ item: HNItem)
}

class NetworkService {
    
    let session: URLSession
    
    var items: Data? {
        didSet {
            decodeMaxItems(items!)
        }
    }
    
    var decodedMaxItems: Int? {
        didSet {
            delegate?.didGetMaxItems(decodedMaxItems!)
        }
    }
    
    weak var delegate: NetworkServiceDelegate?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getDataFromUrl<T>(url: URL, dataType: T) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if dataType is Int.Type {
                    self.items = data
                } else {
                    if let item = try? JSONDecoder().decode(HNItem.self, from: data) {
                        self.delegate?.didGetItem(item)
                    }
                }
            }
        }
        task.resume()
    }
    
    func decodeMaxItems(_ data: Data) {
        decodedMaxItems = try! JSONDecoder().decode(Int.self, from: data)
    }
}
