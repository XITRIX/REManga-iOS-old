//
//  BaseViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import UIKit

class BaseViewController<Model: BaseViewModel>: SAViewController {
    var overlay: UIViewController?
    var viewModel: Model!
    
    deinit {
        print("Deinit: " + Self.description())
    }
    
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
        viewModel.state.observeNext { [unowned self] state in
            switch state {
            case .loading:
                self.addOverlay(LoadingViewController())
            case .failed:
                self.removeOverlay()
                break
            case .done:
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
