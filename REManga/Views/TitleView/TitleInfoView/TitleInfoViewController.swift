//
//  TitleInfoView.swift
//  REManga
//
//  Created by Daniil Vinogradov on 02.03.2021.
//

import Bond
import TTGTagCollectionView
import UIKit

class TitleInfoViewController: BaseViewControllerWith<TitleInfoViewModel, TitleViewModel> {
    @IBOutlet var totalVotes: UILabel!
    @IBOutlet var totalViews: UILabel!
    @IBOutlet var totalBookmarks: UILabel!
    @IBOutlet var titleDescription: UILabel!
    @IBOutlet var tagsCollection: TTGTextTagCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tagsCollection.defaultConfig.cornerRadius = 10
        tagsCollection.defaultConfig.shadowRadius = 0
        tagsCollection.defaultConfig.shadowOffset = .zero
        tagsCollection.defaultConfig.borderWidth = 0
        tagsCollection.defaultConfig.backgroundColor = .tertiarySystemBackground
        tagsCollection.defaultConfig.textColor = .label
        tagsCollection.defaultConfig.textFont = .systemFont(ofSize: 14)
        tagsCollection.defaultConfig.extraSpace = CGSize(width: 24, height: 12)
        tagsCollection.delegate = self
    }

    override func binding() {
        super.binding()
        viewModel.entity.totalViews.bind(to: totalViews).dispose(in: bag)
        viewModel.entity.totalVotes.bind(to: totalVotes).dispose(in: bag)
        viewModel.entity.countBookmarks.bind(to: totalBookmarks).dispose(in: bag)
        viewModel.entity.description.observeNext(with: {
            self.titleDescription.attributedText = $0?.htmlAttributedString()
        }).dispose(in: bag)
        viewModel.entity.categories.observeNext {
            self.tagsCollection.addTags($0.collection.compactMap { $0.name })
        }.dispose(in: bag)
    }

    @IBAction func openDescription(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.isHidden = true
            self.titleDescription.numberOfLines = 0

            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

extension TitleInfoViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTapTag tagText: String!, at index: UInt, currentSelected: Bool, tagConfig config: TTGTextTagConfig!) -> Bool {
        false
    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {}
}
