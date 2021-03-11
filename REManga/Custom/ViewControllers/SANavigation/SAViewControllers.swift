//
//  SAViewController.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 01.04.2020.
//  Copyright © 2020  XITRIX. All rights reserved.
//

import UIKit

protocol NavigationProtocol {
    var toolBarIsHidden: Bool? { get }
    var navigationBarIsHidden: Bool? { get }
    
    func updateNavigationControllerState(animated: Bool)
}

class SAViewController: UIViewController, NavigationProtocol {
    var toolBarIsHidden: Bool? {
        nil
    }
    
    var navigationBarIsHidden: Bool? {
        nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationControllerState(animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController as? SANavigationController,
           nav.viewControllers.last == self
        {
            nav.locker = false
        }
        updateNavigationControllerState(animated: false)
    }
    
    func updateNavigationControllerState(animated: Bool = true) {
        if let toolBarIsHidden = toolBarIsHidden//,
//           navigationController?.isToolbarHidden != toolBarIsHidden
        {
//            navigationController?.isToolbarHidden = toolBarIsHidden
            navigationController?.setToolbarHidden(toolBarIsHidden, animated: animated)
        }
        
        if let navigationBarIsHidden = navigationBarIsHidden//,
//           navigationController?.isNavigationBarHidden != navigationBarIsHidden
        {
//            navigationController?.isNavigationBarHidden = navigationBarIsHidden
            navigationController?.setNavigationBarHidden(navigationBarIsHidden, animated: animated)
        }
    }
}

class SATableViewController: UITableViewController, NavigationProtocol {
    var toolBarIsHidden: Bool? {
        nil
    }
    
    var navigationBarIsHidden: Bool? {
        nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController as? SANavigationController,
           nav.viewControllers.last == self
        {
            nav.locker = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationControllerState()
    }
    
    func updateNavigationControllerState(animated: Bool = true) {
        if let toolBarIsHidden = toolBarIsHidden {
            navigationController?.setToolbarHidden(toolBarIsHidden, animated: animated)
        }
        
        if let navigationBarIsHidden = navigationBarIsHidden {
            navigationController?.setNavigationBarHidden(navigationBarIsHidden, animated: animated)
        }
    }
}
