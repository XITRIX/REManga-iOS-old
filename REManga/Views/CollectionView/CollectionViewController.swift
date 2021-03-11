//
//  CollectionViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit

class CollectionViewController: BaseViewController<CollectionViewModel> {
    override var navigationBarIsHidden: Bool? { false }
    
    enum Section {
        case main
    }
    
    @IBOutlet var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, ReCatalogContent>!
    
    let columns: CGFloat = 3
    var activityView: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: SearchViewController())
    var overlayView: OverlayController!
    
    override func loadView() {
        super.loadView()
        activityView = UIActivityIndicatorView(style: .large)
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, ReCatalogContent>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, content) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCellView.id, for: indexPath) as! CatalogCellView
            cell.setModel(content)
            return cell
        })
    }
    
    override func setView() {
        title = "RE:Manga"
        
        collectionView.register(CatalogCellView.nib, forCellWithReuseIdentifier: CatalogCellView.id)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = self
        
//        searchController.searchBar.placeholder = "Что ищем, семпай?"
//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
        
        overlayView = OverlayController(self, rootVC: SearchViewController())
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showOverlay))
        navigationItem.setRightBarButton(search, animated: false)
    }
    
    @objc func showOverlay() {
        overlayView.show()
    }
    
    @objc func hideOverlay() {
        overlayView.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func binding() {
        super.binding()
        
        viewModel.content.observeNext { [unowned self] content in
            var snapshot = NSDiffableDataSourceSnapshot<Section, ReCatalogContent>()
            snapshot.appendSections([.main])
            snapshot.appendItems(content.collection)
            self.collectionViewDataSource.apply(snapshot)
        }.dispose(in: bag)
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        !overlayView.presented
    }
    
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

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchResultsController as? SearchViewController
        else { return }
        
        search.viewModel.query.value = searchController.searchBar.text ?? ""
    }
}
