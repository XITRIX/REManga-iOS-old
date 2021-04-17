//
//  TitleViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Bond
import Kingfisher
import MarqueeLabel
import UIKit

class TitleViewController: BaseViewControllerWith<TitleViewModel, String> {
    @IBOutlet var backButtonConstraint: NSLayoutConstraint!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var segmentBarView: UIView!
    @IBOutlet var viewContainerHeightConstraint: NSLayoutConstraint!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var headerBottom: UIView!
    @IBOutlet var headerView: UIView!

    @IBOutlet var titleImage: UIImageView!
    @IBOutlet var altTitle: UILabel!
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var titleState: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var continueReadingView: UIControl!
    @IBOutlet var continueReadingLabel: UILabel!
    @IBOutlet var continueReadingChapterLabel: UILabel!

    @IBOutlet var bookmarkLabel: UILabel!
    @IBOutlet var navEffect: UIVisualEffectView!
    var titleView: MarqueeLabel!

    var aboutView: TitleInfoViewController!
    var branchView: BranchViewController!
    var commentsView: CommentsViewController!

    var containedVC: UIViewController?

    var _navigationBarIsHidden: Bool = true
    override var navigationBarIsHidden: Bool? {
        _navigationBarIsHidden
    }

    override func loadView() {
        super.loadView()

        titleView = MarqueeLabel(frame: .zero, rate: 80, fadeLength: 10)
        titleView.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleView.trailingBuffer = 44
        titleView.isHidden = true

        aboutView = TitleInfoViewController(parameter: viewModel)
        branchView = BranchViewController(self, parameter: nil)
    }

    override func setView() {
        scrollView.delegate = self
        navigationItem.titleView = titleView
        navEffect.alpha = 0
        setView(aboutView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearence
    }

    override func binding() {
        super.binding()

        viewModel.id.observeNext { [unowned self] id in
            if let id = id {
                commentsView = CommentsViewController(parameter: CommentsParameters(titleId: id, lock: true))
            }
        }.dispose(in: bag)
        
        backButton.reactive.tap.observeNext { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)

        viewModel.enName.observeNext { [unowned self] in
            self.titleView.text = $0
            self.titleView.sizeToFit()
            self.altTitle.text = $0
        }.dispose(in: bag)

        viewModel.rusName.bind(to: mainTitle).dispose(in: bag)
        viewModel.info.bind(to: titleState).dispose(in: bag)
        viewModel.rating.bind(to: rating).dispose(in: bag)
        viewModel.image.observeNext { [unowned self] in
            self.titleImage.kf.setImage(with: $0)
        }.dispose(in: bag)
        viewModel.branch.observeNext { [unowned self] in
            self.branchView.viewModel.setBranch($0)
        }.dispose(in: bag)

        viewModel.firstChapter.combineLatest(with: viewModel.continueChapter) { (first, next) in
            if first != nil {
                return "Читать"
            } else if next != nil {
                return "Продолжить"
            }
            return "Прочитано"
        }.bind(to: continueReadingLabel.reactive.text).dispose(in: bag)

        viewModel.continueChapter.map {
            $0 == nil
        }.bind(to: continueReadingChapterLabel.reactive.isHidden).dispose(in: bag)

        viewModel.continueChapter.map {
            "Том \(($0?.tome).text) Глава \(($0?.chapter).text)"
        }.bind(to: continueReadingChapterLabel.reactive.text).dispose(in: bag)

        viewModel.bookmark.bind(to: bookmarkLabel.reactive.text).dispose(in: bag)
        
        continueReadingView.reactive.controlEvents(.touchUpInside).observeNext { [unowned self] _ in
            if let chapter = viewModel.firstChapter.value?.id {
                show(ReaderViewController(parameter: ReaderViewModelParams(chapterId: chapter)), sender: self)
            } else if let chapter = viewModel.continueChapter.value?.id {
                show(ReaderViewController(parameter: ReaderViewModelParams(chapterId: chapter)), sender: self)
            }
        }.dispose(in: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerBottom.makeArch()

        viewContainerHeightConstraint.constant =
                (sharedWindow?.frame.height ?? 0) -
                segmentBarView.frame.height

        viewContainerHeightConstraint.constant -=
                (navigationController?.navigationBar.frame.height ?? 0) +
                (sharedSafeArea?.top ?? 0)

        viewContainerHeightConstraint.constant -=
                view.safeAreaInsets.bottom

        scrollView.contentInset.bottom = view.safeAreaInsets.bottom
        
        backButtonConstraint.constant = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 6
    }

    @IBAction func segmentStateChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setView(aboutView)
        case 1:
            let nvc = UINavigationController(rootViewController: branchView)
            nvc.navigationBar.isHidden = true
            setView(nvc)
        case 2:
            setView(commentsView)
        default:
            setView(nil)
        }
    }

    func setView(_ viewController: UIViewController?) {
        containedVC?.remove()
        guard let viewController = viewController
                else {
            return
        }

        addChild(viewController)
        containedVC = viewController
        viewContainer.addSubview(viewController.view)
        viewController.view.fitToParent()
        viewController.didMove(toParent: self)
    }
}

extension TitleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavigationControllerState(animated: false)

        let alpha = max(0, min(1, max(0, (scrollView.contentOffset.y - headerView.frame.height / 2) / headerView.frame.height * 2)))
        navEffect.alpha = alpha

        _navigationBarIsHidden = alpha == 0
        titleView.isHidden = alpha == 0
        UIView.animate(withDuration: 0.3) {
            self.backButton.alpha = self._navigationBarIsHidden ? 1 : 0
            self.updateNavigationControllerState()
        }
    }
}
