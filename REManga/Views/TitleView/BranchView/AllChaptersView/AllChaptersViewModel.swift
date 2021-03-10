//
//  AllChaptersViewModel.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import Bond
import Foundation

class AllChaptersViewModel: BaseViewModelWith<[ReBranchContent]> {
    let chapters = MutableObservableCollection<[ReBranchContent]>()

    override func prepare(_ parameter: [ReBranchContent]) {
        chapters.replace(with: parameter)
        setState(.done)
    }
}
