//
//  ReaderViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 07.03.2021.
//

import Bond
import Foundation

struct ReaderBookmarkState {
    var props: [ReTitleStatus]
    var current: Int?
}

struct ReaderViewModelParams {
    var chapters: [ReBranchContent]
    var current: Int
}

class ReaderViewModel: BaseViewModelWith<ReaderViewModelParams> {
    let name = Observable<String?>(nil)
    let pages = MutableObservableCollection<[ReChapterPage]>()
    
    let prevAvailable = Observable<Bool>(false)
    let nextAvailable = Observable<Bool>(false)
    
    private(set) var parameters: ReaderViewModelParams!

    override func prepare(_ parameters: ReaderViewModelParams) {
        self.parameters = parameters
        loadChapter()
    }
    
    public func loadPrevChapter() {
        ReClient.shared.setViews(chapter: parameters.chapters[parameters.current].id)
        parameters.current += 1
        loadChapter()
    }
    
    public func loadNextChapter() {
        ReClient.shared.setViews(chapter: parameters.chapters[parameters.current].id)
        parameters.current -= 1
        loadChapter()
    }
    
    private func loadChapter() {
        updateStates()
//        self.setState(.loading)
        pages.removeAll()
        name.value = "Глава \(parameters.chapters[parameters.current].chapter.text)"
        ReClient.shared.getChapter(chapter: parameters.chapters[parameters.current].id) { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.setState(.done)
                self.loadModel(model.content)
            }
        }
    }

    private func loadModel(_ model: ReChapterContent) {
        pages.replace(with: model.pages.map {
            $0.parts
        }.flatMap {
            $0
        })
    }
    
    private func updateStates() {
        prevAvailable.value = parameters.chapters.count - 1 > parameters.current
        nextAvailable.value = parameters.current > 0
    }
}
