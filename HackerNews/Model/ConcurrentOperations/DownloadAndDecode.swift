//
//  DownloadAndDecode.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 03.11.2020.
//

import Foundation

class DownloadAndDecode<T: Codable>: ConcurrentOperation<T> {
    
    var url: URL
    var session: URLSession
    var decoder: JSONDecoder
    private var task: URLSessionTask?

    init(_ itemType: T.Type, from url: URL, session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.url = url
        self.session = session
        self.decoder = decoder
    }
    
    override func main() {
        let task = session.dataTask(with: url, completionHandler: completionHandler(_:_:_:))
        task.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    private func completionHandler(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        if let data = data {
            if let item = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    self.complete(result: .success(item))
                }
            }
            self.finish()
        }
    }
}
