//
//  CommentTableViewCell.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 02.11.2020.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var leadingLine: UIView!
    
    @IBOutlet weak var paddingViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
