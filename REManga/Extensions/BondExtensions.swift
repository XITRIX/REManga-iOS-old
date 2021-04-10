//
//  BondExtensions.swift
//  REManga
//
//  Created by Даниил Виноградов on 11.03.2021.
//

import UIKit
import ReactiveKit
import Bond

extension UIButton {
    func bind(_ action: @escaping () -> ()) -> Disposable {
        self.reactive.tap.observeNext(with: action)
    }
}
