//
//  CommentsViewModel.swift
//  REManga
//
//  Created by Даниил Виноградов on 16.04.2021.
//

import Foundation
import Bond

struct CommentsParameters {
    var titleId: Int
    var lock: Bool = false
    var comments: [ReCommentsContent] = []
    var page: Int = 1
}

class CommentsViewModel: BaseViewModelWith<CommentsParameters> {
    let showComments = MutableObservableArray<ReCommentsContent>([])
    let comments = MutableObservableArray<ReCommentsContent>([])
    var titleId: Int!
    var lock: Bool!
    var page = 1
    
    override func prepare(_ parameters: CommentsParameters) {
        titleId = parameters.titleId
        comments.replace(with: parameters.comments)
        page = parameters.page
        lock = parameters.lock
        loadComments()
    }
    
    func loadComments() {
        ReClient.shared.getTitleComments(titleId: titleId, page: page) { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.setState(.done)
                self.comments.replace(with: model.content)
                self.showComments.replace(with: model.content.crop(to: 20))
                self.page += 1
            }
        }
    }
}
