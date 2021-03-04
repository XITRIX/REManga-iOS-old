//
//  BaseViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Foundation
import Bond

enum ModelState {
    case Loading
    case Failed
    case Done
}

class BaseViewModel {
    let state = Observable<ModelState>(.Loading)
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
