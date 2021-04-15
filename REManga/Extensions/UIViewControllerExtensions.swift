//
//  UIViewControllerExtensions.swift
//  REManga
//
//  Created by Daniil Vinogradov on 04.03.2021.
//

import UIKit

extension UIViewController {
    var sharedWindow: UIWindow? {
        UIApplication.shared.windows.first
    }

    var sharedSafeArea: UIEdgeInsets? {
        self.sharedWindow?.safeAreaInsets
    }

    func add(to viewController: UIViewController) {
        viewController.addChild(self)
        self.view.frame = viewController.view.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.addSubview(self.view)
        self.didMove(toParent: viewController)
    }
    
    func insert(to viewController: UIViewController, at: Int) {
        viewController.addChild(self)
        self.view.frame = viewController.view.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.insertSubview(self.view, at: at)
        self.didMove(toParent: viewController)
    }

    func remove() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
