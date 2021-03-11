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
        viewModel = Model()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    @available(*, unavailable)
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        binding()
    }
    
    func setView() {}
    
    func binding() {
        viewModel.state.observeNext { [unowned self] state in
            switch state {
            case .loading:
                self.addOverlay(LoadingViewController())
            case .failed:
                self.removeOverlay()
            case .done:
                self.removeOverlay()
            }
        }.dispose(in: bag)
    }
    
    func addOverlay(_ viewController: UIViewController) {
        removeOverlay()
        viewController.add(to: self)
        overlay = viewController
    }
    
    func removeOverlay() {
        overlay?.remove()
        overlay = nil
    }
}

class BaseViewControllerWith<Model: BaseViewModelWith<Item>, Item: Any>: BaseViewController<Model> {
    init(parameter: Item) {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.main)
        viewModel = Model(parameter: parameter)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
