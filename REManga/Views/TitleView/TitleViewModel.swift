//
//  TitleViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Bond
import Foundation

class TitleViewModel: BaseViewModelWith<String> {
    var props: ReTitleProps?

    let rusName = Observable<String?>(nil)
    let enName = Observable<String?>(nil)
    let info = Observable<String?>(nil)
    let image = Observable<URL?>(nil)
    let rating = Observable<String?>(nil)
    let branch = Observable<Int?>(nil)
    let branches = MutableObservableCollection<[ReTitleBranch]>()
    let totalVotes = Observable<String?>(nil)
    let totalViews = Observable<String?>(nil)
    let countBookmarks = Observable<String?>(nil)
    let description = Observable<String?>(nil)
    let categories = MutableObservableCollection<[ReTitleStatus]>()
    let publishers = MutableObservableCollection<[ReTitlePublisher]>()
    let continueChapter = Observable<ReTitleChapter?>(nil)
    let firstChapter = Observable<ReTitleChapter?>(nil)
    let bookmark = Observable<String?>(nil)

    let similar = MutableObservableCollection<[ReSimilarContent]>()

    override func prepare(_ parameter: String) {
        ReClient.shared.getTitle(title: parameter) { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.props = model.props
                self.loadModel(model.content)
                self.setState(.done)
            }
        }
        loadSimilar(parameter)
    }

    func loadModel(_ model: ReTitleContent) {
        rusName.value = model.rusName
        enName.value = model.enName
        rating.value = "\(model.avgRating.text) (голосов: \(model.countRating.text))"
        info.value = "\((model.type?.name).text) \(model.issueYear.text) \((model.status?.name).text)"
        totalVotes.value = model.totalVotes?.cropText()
        totalViews.value = model.totalViews?.cropText()
        countBookmarks.value = model.countBookmarks?.cropText()
        description.value = model.contentDescription
        categories.replace(with: model.categories ?? [])
        publishers.replace(with: model.publishers ?? [])
        branches.replace(with: model.branches ?? [])
        continueChapter.value = model.continueReading
        firstChapter.value = model.firstChapter
        if let bookmarkType = model.bookmarkType {
            bookmark.value = props?.bookmarkTypes?[bookmarkType].name
        }
        if bookmark.value == nil {
            bookmark.value = "Добавить в закладки"
        }

        if let img = model.img?.high {
            image.value = URL(string: ReClient.baseUrl + img)
        }
        if let _branch = model.activeBranch ?? model.branches?.first?.id {
            branch.value = _branch
        }

    }

    func loadSimilar(_ parameter: String) {
        ReClient.shared.getSimilar(title: parameter) { result in
            switch result {
            case .failure:
                break
            case .success(let model):
                self.similar.replace(with: model.content)
            }
        }
    }
}
