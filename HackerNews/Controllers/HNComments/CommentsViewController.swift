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
    
    var comments = [CommentForDisplay]()
    
    var itemId: Int?
    
    let queryConstructor: HNQueryConstructor
    
    required init?(coder: NSCoder) {
        self.queryConstructor = HNQueryConstructor()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
        
        commentsTableView.register(UINib(nibName: C.Cells.commentCellName, bundle: nil), forCellReuseIdentifier: C.Cells.commentCellId)
        
        commentsTableView.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        
        if let id = itemId {
            let url = queryConstructor.getCommentsUrl(forId: id)
            let download = DownloadAndDecode(HNComment.self, from: url)
            download.completionHandler = { (result) in
                switch result {
                case .success(let comment):
                    self.comments = self.parse(comment.children, level: 0)
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
    
    func parse(_ comments: [HNComment], level: Int) -> [CommentForDisplay] {
        let color = UIColor.random
        let result = comments.flatMap { (comment) -> [CommentForDisplay] in
            var forDisplay = [CommentForDisplay(text: comment.text, author: comment.author, level: level, color: color)]
            if !comment.children.isEmpty {
                forDisplay.append(contentsOf: parse(comment.children, level: level + 1))
            }
            return forDisplay
        }
        return result
    }
}

//MARK: - Table view data source

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Cells.commentCellId, for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.titleLabel.text = comment.author
        if let content = comment.text {
            cell.contentLabel.setHTMLFromString(htmlText: content)
        } else {
            cell.contentLabel.text = ""
        }
        let level = comment.level
        cell.paddingViewWidth.constant = CGFloat(level * 10 + 10)
        if level == 0 {
            cell.leadingLine.isHidden = true
        } else {
            cell.leadingLine.isHidden = false
            cell.leadingLine.backgroundColor = comment.color
        }
        
        return cell
    }
}


