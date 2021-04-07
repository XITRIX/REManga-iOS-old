//
//  UserHeaderView.swift
//  REManga
//
//  Created by Даниил Виноградов on 12.03.2021.
//

import UIKit

@IBDesignable
class UserHeaderView: UIView {
    @IBOutlet var root: UIView!

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userId: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var titlesReaded: UILabel!
    @IBOutlet var userCurrency: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseInit()
    }

    func baseInit() {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)

        root.frame = bounds
        root.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(root)
    }
}
