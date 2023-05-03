//
//  NewsTableViewCell.swift
//  Pixels News
//
//  Created by Alief Azies on 16/10/21.
//

import UIKit

protocol NewsTableViewCellDelegate: NSObjectProtocol {
    func newsTableViewCellBookmarkButtonTapped(_ cell: NewsTableViewCell)
}

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var thumbImageLabel: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var delegate: NewsTableViewCellDelegate?
    
    var closure: ((NewsTableViewCell)-> Void) = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOnBookmarkButtonTapped(closure: @escaping (NewsTableViewCell) -> Void) {
        self.closure = closure
    }
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
//        delegate?.newsTableViewCellBookmarkButtonTapped(self)
        closure(self)
    }
    
}
