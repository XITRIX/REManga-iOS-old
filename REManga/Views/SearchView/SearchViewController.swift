//
//  SearchViewController.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import UIKit

class SearchViewController: BaseViewController<SearchViewModel> {
    enum Section {
        case main
    }
    
    @IBOutlet var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, ReSearchContent>!
    
    let columns: CGFloat = 3
    
    override func loadView() {
        super.loadView()
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, ReSearchContent>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, content) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCellView.id, for: indexPath) as! CatalogCellView
            cell.setModel(content)
            return cell
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CatalogCellView.nib, forCellWithReuseIdentifier: CatalogCellView.id)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = self
    }
    
    override func binding() {
        super.binding()
        
        viewModel.content.observeNext { [unowned self] content in
            var snapshot = NSDiffableDataSourceSnapshot<Section, ReSearchContent>()
            snapshot.appendSections([.main])
            snapshot.appendItems(content.collection)
            self.collectionViewDataSource.apply(snapshot)
        }.dispose(in: bag)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - 200 {
//            viewModel.loadNext()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dir = viewModel.content[indexPath.item].dir
        else { return }
        
        let root = TitleViewController(parameter: dir)
        sharedWindow?.rootViewController?.show(root, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWithoutInset: CGFloat = (collectionView.frame.width - 24)
        let frameSeparators = CGFloat(10 * (columns - 1))
        let itemWidth = CGFloat((frameWithoutInset - frameSeparators) / columns)
        
        return CGSize(width: itemWidth, height: itemWidth / 0.56)
    }
}
