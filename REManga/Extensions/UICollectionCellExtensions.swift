//
//  UICollectionCellExtensions.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import UIKit

extension UITableViewCell {
    static var id: String {
        String(describing: Self.self)
    }
    static var nib: UINib {
        UINib(nibName: id, bundle: Bundle.main)
    }
    static func register(in tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: id)
    }
}

extension UICollectionViewCell {
    static var id: String {
        String(describing: Self.self)
    }
    static var nib: UINib {
        UINib(nibName: id, bundle: Bundle.main)
    }
    static func register(in collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: id)
    }
}
