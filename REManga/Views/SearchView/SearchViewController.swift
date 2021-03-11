//
//  SearchViewController.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import UIKit
import Bond

class SearchViewController: BaseViewController<SearchViewModel> {
    override var navigationBarIsHidden: Bool? { false }
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
   
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, ReSearchContent>!
    
    var columns: CGFloat { view.traitCollection.horizontalSizeClass == .compact ? 3 : 5 }
    
    override func loadView() {
        super.loadView()
        
        searchBar.backgroundImage = UIImage()
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, ReSearchContent>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, content) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCellView.id, for: indexPath) as! CatalogCellView
            cell.setModel(content)
            return cell
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func setView() {
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
        
        viewModel.query.bidirectionalBind(to: searchBar.reactive.text).dispose(in: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewDataSource.apply(collectionViewDataSource.snapshot())
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
