//
//  TitleInfoSimilarCell.swift
//  REManga
//
//  Created by Daniil Vinogradov on 04.03.2021.
//

import UIKit

class TitleInfoSimilarCell: UICollectionViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var details: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var totalFavorites: UILabel!
    
    func setModel(_ model: ReSimilarContent) {
        name.text = model.rusName
        details.text = model.type
        totalFavorites.text = model.totalVotes?.cropText()
        image.kf.setImage(with: URL(string: ReClient.baseUrl + (model.img?.mid).text))
    }
}
