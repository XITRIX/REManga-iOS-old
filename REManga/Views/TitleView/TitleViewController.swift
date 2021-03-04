//
//  TitleViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import UIKit
import Bond
import Kingfisher

class TitleViewController: BaseViewControllerWith<TitleViewModel, String> {
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var headerBottom: UIView!
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var titleImage: UIImageView!
    @IBOutlet var altTitle: UILabel!
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var titleState: UILabel!
    @IBOutlet var rating: UILabel!
    
    @IBOutlet var navEffect: UIVisualEffectView!
    var titleView: UILabel!
    
    var aboutView: TitleInfoViewController!
    var branchView: BranchViewController!
    
    var containedVC: UIViewController?
    
    override func loadView() {
        super.loadView()
        
        titleView = UILabel()
        titleView.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        aboutView = TitleInfoViewController(parameter: viewModel)
        branchView = BranchViewController(parameter: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearence
        
        navigationItem.titleView = titleView
        
        navEffect.alpha = 0
        titleView.alpha = 0
        titleView.isHidden = true

        setView(aboutView)
    }
    
    override func binding() {
        super.binding()
        viewModel.enName.observeNext {
            self.titleView.text = $0
            self.titleView.sizeToFit()
            self.altTitle.text = $0
        }.dispose(in: bag)
        
        viewModel.rusName.bind(to: mainTitle).dispose(in: bag)
        viewModel.info.bind(to: titleState).dispose(in: bag)
        viewModel.rating.bind(to: rating).dispose(in: bag)
        viewModel.image.observeNext {
            self.titleImage.kf.setImage(with: $0)
        }.dispose(in: bag)
        viewModel.branch.observeNext {
            self.branchView.viewModel.setBranch($0)
        }.dispose(in: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerBottom.makeArch()
    }
    
    @IBAction func segmentStateChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setView(aboutView)
            break
        case 1:
            setView(branchView)
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
        
        containedVC = viewController
        viewContainer.addSubview(viewController.view)
        viewController.view.fitToParent()
        viewController.didMove(toParent: self)
    }
}

extension TitleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = max(0, min(1, max(0, (scrollView.contentOffset.y - headerView.frame.height / 2) / headerView.frame.height * 2)))
        navEffect.alpha = alpha
        titleView.alpha = alpha
        titleView.isHidden = alpha == 0
    }
}
