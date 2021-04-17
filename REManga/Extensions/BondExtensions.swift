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

extension ReactiveExtensions where Base: UITableView {
    
//    /// A signal that emits index paths of selected table view cells.
//    ///
//    /// - Note: Uses table view's `delegate` protocol proxy to observe calls made to `UITableViewDelegate.tableView(_:didSelectRowAt:)` method.
//    public var selectedRowIndexPath: SafeSignal<IndexPath> {
//        return delegate.signal(for: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))) { (subject: PassthroughSubject<IndexPath, Never>, _: UITableView, indexPath: IndexPath) in
//            subject.send(indexPath)
//        }
//    }
//
//    /// A signal that emits index paths of selected table view cells.
//    ///
//    /// - Note: Uses table view's `delegate` protocol proxy to observe calls made to `UITableViewDelegate.tableView(_:didSelectRowAt:)` method.
//    public var selectedRowIndexPath: SafeSignal<IndexPath> {
//        return delegate.signal(for: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))) { (subject: PassthroughSubject<IndexPath, Never>, _: UITableView, indexPath: IndexPath) in
//            subject.send(indexPath)
//        }
//    }
}

//class A: NSObject, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
//    cell
//}
