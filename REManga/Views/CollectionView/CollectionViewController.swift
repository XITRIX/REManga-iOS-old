//
//  CollectionViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit

class CollectionViewController: BaseViewController<CollectionViewModel> {
    @IBOutlet var collectionView: UICollectionView!
    
    override var navigationBarIsHidden: Bool? { false }
    
    let columns: CGFloat = 3
    var activityView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        activityView = UIActivityIndicatorView(style: .large)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RE:Manga"
        collectionView.register(CatalogCellView.nib, forCellWithReuseIdentifier: CatalogCellView.id)
        collectionView.delegate = self
        
        binding()
    }
    
    override func binding() {
        super.binding()
        
        viewModel.content.bind(to: collectionView) { (content, indexPath, collectionView) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCellView.id, for: indexPath) as! CatalogCellView
            cell.setModel(content[indexPath.item])
            return cell
        }.dispose(in: bag)
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - 200 {
            viewModel.loadNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dir = viewModel.content[indexPath.item].dir
        else { return }
        
        let root = TitleViewController(parameter: dir)
        show(root, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWithoutInset: CGFloat = (collectionView.frame.width - 24)
        let frameSeparators = CGFloat(10 * (columns - 1))
        let itemWidth = CGFloat((frameWithoutInset - frameSeparators) / columns)
        
        return CGSize(width: itemWidth, height: itemWidth / 0.56)
    }
}
