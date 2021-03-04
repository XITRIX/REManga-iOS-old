//
//  TagCell.swift
//  REManga
//
//  Created by Daniil Vinogradov on 04.03.2021.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let id = "TagCell"
    static let nib = UINib(nibName: id, bundle: Bundle.main)

    @IBOutlet var name: UILabel!
    
    func setModel(_ model: ReTitleStatus) {
        name.text = model.name
    }
}
