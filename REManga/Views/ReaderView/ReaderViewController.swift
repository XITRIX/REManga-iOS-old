//
//  ReaderViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import UIKit

class ReaderViewController: BaseViewControllerWith<ReaderViewModel, Int> {
    @IBOutlet var collectionView: UICollectionView!
    
    var _navigationBarIsHidden: Bool = false
    override var navigationBarIsHidden: Bool? { _navigationBarIsHidden }
    
    override func setView() {
        collectionView.contentInset.top = (sharedSafeArea?.top ?? 0) + (navigationController?.navigationBar.frame.height ?? 0)
        collectionView.register(ReaderPageCell.nib, forCellWithReuseIdentifier: ReaderPageCell.id)
        collectionView.delegate = self
    }

    override func binding() {
        super.binding()
        viewModel.pages.bind(to: collectionView) { (pages, indexPath, collectionView) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReaderPageCell.id, for: indexPath) as! ReaderPageCell
            cell.setModel(pages[indexPath.row])
            return cell
        }
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleNavigationHidden)))
    }
    
    @objc func toggleNavigationHidden() {
        if collectionView.contentOffset.y <= collectionView.contentInset.top {
            return
        }
        
        _navigationBarIsHidden = !_navigationBarIsHidden
        updateNavigationControllerState()
    }
}

extension ReaderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let page = viewModel.pages.collection[indexPath.row]
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width / CGFloat(page.width) * CGFloat(page.height))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: view).y
        
        if velocity < -300 {
            _navigationBarIsHidden = true
        } else if velocity > 1000 {
            _navigationBarIsHidden = false
        }
        
        if scrollView.contentOffset.y <= 44 {
            _navigationBarIsHidden = false
        }
        
        updateNavigationControllerState()
    }
}
