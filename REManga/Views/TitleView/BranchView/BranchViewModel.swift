//
//  BranchViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import Bond
import Foundation

class BranchViewModel: BaseViewModelWith<Int?> {
    var chapters = MutableObservableArray<ReBranchContent>()
    var chaptersToShow = MutableObservableArray<ReBranchContent>()

    override func prepare(_ parameter: Int?) {
        setBranch(parameter)
    }

    func setBranch(_ parameter: Int?) {
        guard let parameter = parameter
                else {
            return
        }

        ReClient.shared.getBranch(branch: parameter) { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.setState(.done)
                self.chapters.replace(with: model.content)
                self.chaptersToShow.replace(with: model.content.crop(to: 20))
            }
        }
    }
}
