//
//  OverlayController.swift
//  REManga
//
//  Created by Даниил Виноградов on 11.03.2021.
//

import UIKit

class OverlayController: SAViewController {
    weak var parentVC: UIViewController!
    var rootVC: UIViewController!

    private(set) var presented: Bool = false
    private var bottomConstraint: NSLayoutConstraint?
    
    lazy var horizontalOffset: CGFloat = {
        view.frame.width * 0.05
    }()
    
    lazy var verticalOffset: CGFloat = {
        view.frame.height * 0.1
    }()

    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let fxBackground: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    init(_ parentViewController: UIViewController, rootVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.parentVC = parentViewController
        self.rootVC = rootVC
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        setupContainer()

        fxBackground.frame = view.bounds
        view.insertSubview(fxBackground, at: 0)

        fxBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))

        addChild(rootVC)
        rootVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootVC.view.frame = container.bounds
        container.addSubview(rootVC.view)
        rootVC.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootVC.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootVC.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootVC.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        rootVC.viewDidDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        
        KeyboardHelper.shared.isHidden.observeNext { [unowned self] hidden in
            self.bottomConstraint?.constant = hidden ? self.verticalOffset : KeyboardHelper.shared.visibleHeight.value + self.horizontalOffset
            
            UIView.animate(withDuration: KeyboardHelper.shared.animationDuration.value) {
                view.layoutIfNeeded()
            }
        }.dispose(in: bag)
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        hide {
            self.parentVC.show(vc, sender: sender)
        }
    }

    func show(completion: (() -> ())? = nil) {
        if presented { return }
        presented = true
        
        let vc = parentVC.navigationController ?? parentVC!

        vc.addChild(self)
        view.frame = vc.view.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.view.addSubview(view)
        didMove(toParent: vc)

        view.alpha = 0
        
        viewWillAppear(true)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        } completion: { _ in
            self.viewDidAppear(true)
            completion?()
        }
    }

    func hide(completion: (() -> ())? = nil) {
        if !presented { return }
        presented = false

        viewWillDisappear(true)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0
        } completion: { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()

            self.viewDidDisappear(true)
            completion?()
        }
    }

    @objc private func hide() {
        hide(completion: nil)
    }

    private func setupContainer() {
        view.addSubview(container)

        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalOffset).isActive = true
        
        bottomConstraint = view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: verticalOffset)
        bottomConstraint?.isActive = true
    }
}
