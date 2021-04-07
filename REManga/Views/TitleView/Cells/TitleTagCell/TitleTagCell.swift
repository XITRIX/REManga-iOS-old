//
//  TitleTagCell.swift
//  REManga
//
//  Created by Daniil Vinogradov on 02.03.2021.
//

import UIKit

class TitleTagCell: UICollectionViewCell {
    @IBOutlet var name: UILabel!

    func setName(_ name: String) {
        self.name.text = name
    }
}
