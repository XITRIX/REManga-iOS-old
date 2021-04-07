//
//  BranchChapterCell.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit

class BranchChapterCell: UITableViewCell {
    @IBOutlet var tome: UILabel!
    @IBOutlet var chapter: UILabel!
    @IBOutlet var pubDate: UILabel!
    @IBOutlet var publishers: UILabel!
    @IBOutlet var score: UILabel!

    func setModel(_ model: ReBranchContent) {
        tome.text = model.tome.text
        chapter.text = "Глава \(model.chapter.text)"
        publishers.text = model.publishers?.compactMap {
            $0.name
        }.joined(separator: " ")
        score.text = model.score?.cropText()

    }
}
