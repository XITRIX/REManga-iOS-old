//
//  BaseViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Foundation
import ReactiveKit
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
    let bag = DisposeBag()
    let state = Observable<ModelState>(.loading)
    
    required init() {
        prepare()
    }
    
    func setState(_ state: ModelState) {
        self.state.value = state
    }
    
    func prepare() { }
}

class BaseViewModelWith<T>: BaseViewModel {
    required init(parameter: T) {
        super.init()
        prepare(parameter)
    }
    
    func prepare(_ parameter: T) { }
    
    @available(*, unavailable)
    required init() { }
    
    @available(*, unavailable)
    override func prepare() { }
}
