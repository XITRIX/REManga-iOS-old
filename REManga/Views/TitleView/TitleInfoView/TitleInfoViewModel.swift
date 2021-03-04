//
//  TitleInfoViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 02.03.2021.
//

import Foundation

class TitleInfoViewModel: BaseViewModelWith<TitleViewModel> {
    private(set) var entity: TitleViewModel!
    
    override func prepare(_ parameter: TitleViewModel) {
        entity = parameter
        setState(.Done)
    }
}
