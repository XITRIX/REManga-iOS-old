//
//  BaseViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Foundation
import Bond

enum ModelState: Equatable {
    case loading
    case failed(Error)
    case done
    
    static func == (lhs: ModelState, rhs: ModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.done, .done):
            return true
        case (.failed(let r1), .failed(let r2)):
            return r1.localizedDescription == r2.localizedDescription
        default:
            return false
        }
    }
}

class BaseViewModel {
    let state = Observable<ModelState>(.loading)
    required init() { }
    
    func setState(_ state: ModelState) {
        self.state.value = state
    }
}

class BaseViewModelWith<T>: BaseViewModel {
    required init(parameter: T) {
        super.init()
        prepare(parameter)
    }
    
    func prepare(_ parameter: T) { }
    
    @available(*, unavailable)
    required init() { }
}
