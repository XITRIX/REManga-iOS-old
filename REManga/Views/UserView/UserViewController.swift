//
//  UserViewController.swift
//  REManga
//
//  Created by Даниил Виноградов on 12.03.2021.
//

import UIKit

class UserViewController: BaseViewController<UserViewModel> {
    @IBOutlet var header: UserHeaderView!

    override func binding() {
        super.binding()

        viewModel.user.observeNext { [unowned self] user in
            guard let user = user else {
                return
            }

            self.header.userId.text = "ID: \(user.id)"
            self.header.userName.text = user.username
            self.header.userImage.kf.setImage(with: user.avatar?.withBaseUrl())
            self.header.userCurrency.text = "Баланс \(user.balance)"
            self.header.titlesReaded.text = "Прочитано глав: \(user.chaptersRead)"
        }.dispose(in: bag)
    }
}
