//
//  BaseViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import UIKit

class BaseViewController<Model: BaseViewModel>: UIViewController {
    var overlay: UIViewController?
    var viewModel: Model!
    
    init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.main)
        viewModel = Model.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    func binding() {
        viewModel.state.observeNext { state in
            switch state {
            case .Loading:
                self.addOverlay(LoadingViewController())
            case .Failed:
                self.removeOverlay()
                break
            case .Done:
                self.removeOverlay()
                break
            }
        }.dispose(in: bag)
    }
    
    func addOverlay(_ viewController: UIViewController) {
        removeOverlay()
        viewController.addTo(self)
        self.overlay = viewController
    }
    
    func removeOverlay() {
        overlay?.remove()
        overlay = nil
    }
}

class BaseViewControllerWith<Model: BaseViewModelWith<Item>, Item: Any>: BaseViewController<Model> {
    init(parameter: Item) {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.main)
        viewModel = Model.init(parameter: parameter)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UIViewController {
    func addTo(_ viewController: UIViewController) {
        viewController.addChild(self)
        self.view.frame = viewController.view.frame
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.addSubview(self.view)
        self.didMove(toParent: viewController)
    }
    
    func remove() {
        self.removeFromParent()
        self.view.removeFromSuperview()
        self.didMove(toParent: nil)
    }
}
