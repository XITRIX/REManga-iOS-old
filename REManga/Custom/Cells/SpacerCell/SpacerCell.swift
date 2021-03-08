//
//  SpacerCell.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit

class SpacerCell: UITableViewCell {
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var loadingIndicatior: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ tableView: UITableView, offset: CGFloat = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            tableView.beginUpdates()
            let scale = tableView.frame.height
            self.heightConstraint.constant = max(44, scale)
            tableView.endUpdates()
        }
    }
    
}
