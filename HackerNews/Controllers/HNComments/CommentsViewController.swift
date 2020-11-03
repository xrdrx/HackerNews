//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 01.11.2020.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var comments = [HNComment]()
    
    var itemId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
        
        commentsTableView.register(UINib(nibName: C.Cells.commentCellName, bundle: nil), forCellReuseIdentifier: C.Cells.commentCellId)
        
        commentsTableView.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        
        if let id = itemId {
            let download = DownloadComments(for: id)
            download.completionHandler = { (result) in
                switch result {
                case .success(let comment):
                    self.comments = self.parse(comment, level: 0)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.commentsTableView.isHidden = false
                        self.commentsTableView.reloadData()
                    }
                default:
                    return
                }
            }
            download.start()
        }
    }
    
    func parse(_ comment: HNComment, level: Int) -> [HNComment] {
        var result = [HNComment]()
        result.append(HNComment(id: comment.id,
                                parent_id: comment.parent_id,
                                text: comment.text,
                                author: comment.author,
                                children: comment.children,
                                level: level))
        if !comment.children.isEmpty {
            for child in comment.children {
                result.append(contentsOf: parse(child, level: level + 1))
            }
        }
        return result
    }
}

class DownloadComments: ConcurrentOperation<HNComment> {
    
    private var task: URLSessionTask?
    var url: String
    
    init(for id: Int) {
        self.url = "https://hn.algolia.com/api/v1/items/\(id)"
    }
    
    override func main() {
        let url = URL(string: self.url)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: completionHandler(_:_:_:))
        task.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    private func completionHandler(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        if let data = data {
            if let item = try? JSONDecoder().decode(HNComment.self, from: data) {
                DispatchQueue.main.async {
                    self.complete(result: .success(item))
                }
            }
            self.finish()
        }
    }
}

//MARK: - Table view data source

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.titleLabel.text = comment.author
        if let content = comment.text {
            cell.contentLabel.setHTMLFromString(htmlText: content)
        } else {
            cell.contentLabel.text = ""
        }
        if let level = comment.level {
            cell.paddingViewWidth.constant = CGFloat(level * 10 + 10)
        }
        
        return cell
    }
    
    
}


