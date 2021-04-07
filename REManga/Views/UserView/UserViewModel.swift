//
//  UserViewModel.swift
//  REManga
//
//  Created by Даниил Виноградов on 12.03.2021.
//

import Foundation
import Bond

class UserViewModel: BaseViewModel {
    let user = Observable<ReUserContent?>(nil)

    override func prepare() {
        ReClient.shared.getCurrent { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.setState(.done)
                self.user.value = model.content
            }
        }
    }
}
