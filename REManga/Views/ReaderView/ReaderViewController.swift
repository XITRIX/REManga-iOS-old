//
//  ReaderViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import UIKit

class ReaderViewController: BaseViewControllerWith<ReaderViewModel, ReaderViewModelParams> {
    @IBOutlet var prevChapter: UIButton!
    @IBOutlet var chapter: UIButton!
    @IBOutlet var nextChapter: UIButton!
    @IBOutlet var bookmark: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var topBar: UIVisualEffectView!
    @IBOutlet var bottomBar: UIVisualEffectView!

    var _navigationBarIsHidden: Bool = false

    override var swipeAnywhereDisabled: Bool {
        true
    }

    override var navigationBarIsHidden: Bool? {
        true
    }

    override var hidesBottomBarWhenPushed: Bool {
        get { true }
        set {}
    }

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
        }.dispose(in: bag)

        backButton.reactive.tap.observeNext { [unowned self] _ in
            navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
        
        viewModel.name.bind(to: chapter.reactive.title).dispose(in: bag)
        
        viewModel.prevAvailable.bind(to: prevChapter.reactive.isEnabled).dispose(in: bag)
        viewModel.nextAvailable.bind(to: nextChapter.reactive.isEnabled).dispose(in: bag)
        prevChapter.bind(viewModel.loadPrevChapter).dispose(in: bag)
        nextChapter.bind(viewModel.loadNextChapter).dispose(in: bag)

        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleNavigationHidden)))
    }

    @objc func toggleNavigationHidden() {
        if collectionView.contentOffset.y <= collectionView.contentInset.top {
            return
        }

        _navigationBarIsHidden = !_navigationBarIsHidden

        UIView.animate(withDuration: 0.3) {
            self.topBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? -self.topBar.frame.height : 0)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? self.bottomBar.frame.height : 0)
        }
    }
}

extension ReaderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let page = viewModel.pages.collection[indexPath.row]
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * CGFloat(page.height) / CGFloat(page.width))
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

        UIView.animate(withDuration: 0.3) {
            self.topBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? -self.topBar.frame.height : 0)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? self.bottomBar.frame.height : 0)
        }
    }
}
