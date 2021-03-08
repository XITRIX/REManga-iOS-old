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
    @IBOutlet var publishersStack: UIStackView!
    @IBOutlet var similarsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarsCollection.register(TitleInfoSimilarCell.nib, forCellWithReuseIdentifier: TitleInfoSimilarCell.id)

        tagsCollection.defaultConfig.cornerRadius = 10
        tagsCollection.defaultConfig.shadowRadius = 0
        tagsCollection.defaultConfig.shadowOffset = .zero
        tagsCollection.defaultConfig.borderWidth = 0
        tagsCollection.defaultConfig.backgroundColor = .tertiarySystemBackground
        tagsCollection.defaultConfig.textColor = .label
        tagsCollection.defaultConfig.textFont = .systemFont(ofSize: 14)
        tagsCollection.defaultConfig.extraSpace = CGSize(width: 24, height: 12)
        tagsCollection.delegate = self
        
        publishersStack.translatesAutoresizingMaskIntoConstraints = false;
    }

    override func binding() {
        super.binding()
        viewModel.entity.totalViews.bind(to: totalViews).dispose(in: bag)
        viewModel.entity.totalVotes.bind(to: totalVotes).dispose(in: bag)
        viewModel.entity.countBookmarks.bind(to: totalBookmarks).dispose(in: bag)
        viewModel.entity.description.observeNext(with: { [unowned self] in
            self.titleDescription.attributedText = $0?.htmlAttributedString()
        }).dispose(in: bag)
        viewModel.entity.categories.observeNext { [unowned self] in
            self.tagsCollection.addTags($0.collection.compactMap { $0.name })
        }.dispose(in: bag)
        viewModel.entity.publishers.observeNext { [unowned self] (publishers) in
            for publisher in publishers.collection {
                let translator = TitleInfoTranslatorView(model: publisher)
                self.publishersStack.addArrangedSubview(translator)
            }
        }.dispose(in: bag)
        viewModel.entity.similar.bind(to: similarsCollection) { (models, indexPath, collectionView) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleInfoSimilarCell.id, for: indexPath) as! TitleInfoSimilarCell
            cell.setModel(models[indexPath.item])
            return cell
        }.dispose(in: bag)
        similarsCollection.reactive.selectedItemIndexPath.observeNext { [unowned self] indexPath in
            if let dir = self.viewModel.entity.similar[indexPath.item].dir {
                self.parent?.show(TitleViewController(parameter: dir), sender: self)
            }
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
