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
        sharedWindow?.safeAreaInsets
    }
    
    func addTo(_ viewController: UIViewController) {
        viewController.addChild(self)
        self.view.frame = viewController.view.frame
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.addSubview(self.view)
        self.didMove(toParent: viewController)
    }
    
    func remove() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
