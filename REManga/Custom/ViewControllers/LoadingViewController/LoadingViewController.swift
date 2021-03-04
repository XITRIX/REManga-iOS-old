//
//  LoadingViewController.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import UIKit

class LoadingViewController: UIViewController {
    
    init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
