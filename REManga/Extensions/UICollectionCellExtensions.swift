//
//  UICollectionCellExtensions.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import UIKit

extension UITableViewCell {
    static var id: String { String(describing: Self.self) }
    static var nib: UINib { UINib(nibName: id, bundle: Bundle.main) }
}

extension UICollectionViewCell {
    static var id: String { String(describing: Self.self) }
    static var nib: UINib { UINib(nibName: id, bundle: Bundle.main) }
}
