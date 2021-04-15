//
//  ReaderViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import UIKit

class ReaderViewController: BaseViewControllerWith<ReaderViewModel, ReaderViewModelParams> {
    @IBOutlet var closeButtons: [UIButton]!
    @IBOutlet var chapter: UIButton!
    @IBOutlet var prevChapterButtons: [UIButton]!
    @IBOutlet var nextChapterButtons: [UIButton]!
    @IBOutlet var bookmark: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topBar: UIVisualEffectView!
    @IBOutlet var bottomBar: UIVisualEffectView!
    
    @IBOutlet var lastFrameView: UIView!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
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
        tableView.contentInset.top = view.safeAreaInsets.top
        tableView.register(ReaderPageCell.nib, forCellReuseIdentifier: ReaderPageCell.id)
        tableView.delegate = self
        
        lastFrameView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height )
        lastFrameView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = lastFrameView
    }

    override func binding() {
        super.binding()
        
        viewModel.score.bind(to: likesLabel).dispose(in: bag)
        
        viewModel.rated.observeNext { [unowned self] rated in
            likeButton.setImage(UIImage(systemName: rated ? "heart.fill" : "heart"), for: .normal)
        }.dispose(in: bag)
        
        viewModel.pages.bind(to: tableView) { (pages, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: ReaderPageCell.id, for: indexPath) as! ReaderPageCell
            cell.setModel(pages[indexPath.row])
            return cell
        }.dispose(in: bag)

        closeButtons.forEach{$0.bind { [unowned self] in
            navigationController?.popViewController(animated: true)
        }.dispose(in: bag)}
        
        viewModel.name.bind(to: chapter.reactive.title).dispose(in: bag)
        
        prevChapterButtons.forEach {
            viewModel.prevAvailable.bind(to: $0.reactive.isEnabled).dispose(in: bag)
            $0.bind(viewModel.loadPrevChapter).dispose(in: bag)
        }
        
        nextChapterButtons.forEach {
            viewModel.nextAvailable.bind(to: $0.reactive.isEnabled).dispose(in: bag)
            $0.bind(viewModel.loadNextChapter).dispose(in: bag)
        }

        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleNavigationHidden)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset.top = topBar.frame.height
    }
    
    override func stateChanged(_ state: ModelState) {
        switch state {
        case .loading:
            addOverlay(LoadingViewController(), at: 1)
        default:
            super.stateChanged(state)
        }
    }

    @objc func toggleNavigationHidden() {
        if tableView.contentOffset.y <= tableView.contentInset.top {
            return
        }

        setShowBars(!_navigationBarIsHidden)
    }
    
    func setShowBars(_ show: Bool) {
        _navigationBarIsHidden = show
        UIView.animate(withDuration: 0.3) {
            self.topBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? -self.topBar.frame.height : 0)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? self.bottomBar.frame.height : 0)
            
            if self._navigationBarIsHidden {
                self.tableView.scrollIndicatorInsets = .zero
            } else {
                self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: self.topBar.frame.height, left: 0, bottom: self.bottomBar.frame.height, right: 0)
            }
        }
    }
}

extension ReaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let page = viewModel.pages.collection[indexPath.row]
        return (tableView.frame.width * CGFloat(page.height) / CGFloat(page.width)).rounded(.up)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: view).y

        if velocity < -300 {
            setShowBars(true)
        } else if velocity > 1000 {
            setShowBars(false)
        }

        if scrollView.contentOffset.y <= 44 {
            setShowBars(false)
        }
    }
}
