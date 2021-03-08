//
//  TitleViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import UIKit
import Bond
import Kingfisher
import MarqueeLabel

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
    
    @IBOutlet var navEffect: UIVisualEffectView!
    var titleView: MarqueeLabel!
    
    var aboutView: TitleInfoViewController!
    var branchView: BranchViewController!
    
    var containedVC: UIViewController?
    
    var _navigationBarIsHidden: Bool?
    override var navigationBarIsHidden: Bool? { _navigationBarIsHidden }
    
    override func loadView() {
        super.loadView()
        
        titleView = MarqueeLabel(frame: .zero, rate: 80, fadeLength: 10)
        titleView.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleView.trailingBuffer = 44
        
        aboutView = TitleInfoViewController(parameter: viewModel)
        branchView = BranchViewController(self, parameter: nil)
        
        backButtonConstraint.constant = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        navigationItem.titleView = titleView
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearence
        
        navEffect.alpha = 0

        setView(aboutView)
    }
    
    override func binding() {
        super.binding()
        
        viewModel.state.observeNext { [unowned self] state in
            if state == .done {
                self._navigationBarIsHidden = true
                self.updateNavigationControllerState()
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerBottom.makeArch()
        
        viewContainerHeightConstraint.constant =
            (sharedWindow?.frame.height ?? 0) -
            (navigationController?.navigationBar.frame.height ?? 0)
            
        viewContainerHeightConstraint.constant -=
            (sharedSafeArea?.top ?? 0) +
            (sharedSafeArea?.bottom ?? 0) +
            segmentBarView.frame.height
    }
    
    @IBAction func segmentStateChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setView(aboutView)
            break
        case 1:
            let nvc = UINavigationController(rootViewController: branchView)
            nvc.navigationBar.isHidden = true
            setView(nvc)
            break
        default:
            setView(nil)
            break
        }
    }
    
    func setView(_ viewController: UIViewController?) {
        containedVC?.remove()
        guard let viewController = viewController
        else { return }
        
        addChild(viewController)
        containedVC = viewController
        viewContainer.addSubview(viewController.view)
        viewController.view.fitToParent()
        viewController.didMove(toParent: self)
    }
}

extension TitleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateNavigationControllerState(animated: false)
        
        let alpha = max(0, min(1, max(0, (scrollView.contentOffset.y - headerView.frame.height / 2) / headerView.frame.height * 2)))
        navEffect.alpha = alpha
        
        _navigationBarIsHidden = alpha == 0
        UIView.animate(withDuration: 0.3) {
            self.backButton.alpha = self._navigationBarIsHidden! ? 1 : 0
            self.updateNavigationControllerState()
        }
    }
}
