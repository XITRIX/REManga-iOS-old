//
//  ReaderViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import Bond
import Foundation

class ReaderViewModel: BaseViewModelWith<Int> {
    let name = Observable<String?>(nil)
    let pages = MutableObservableCollection<[ReChapterPage]>()

    override func prepare(_ parameter: Int) {
        ReClient.shared.getChapter(chapter: parameter) { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.setState(.done)
                self.loadModel(model.content)
            }
        }
    }

    func loadModel(_ model: ReChapterContent) {
        name.value = model.name
        pages.replace(with: model.pages.map {
            $0.parts
        }.flatMap {
            $0
        })
    }
}
