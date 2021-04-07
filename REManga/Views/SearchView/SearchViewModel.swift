//
//  SearchViewModel.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import Bond
import Foundation
import Alamofire

class SearchViewModel: BaseViewModel {
    let content = MutableObservableCollection<[ReSearchContent]>()

    let page = Observable<Int>(1)
    let query = Observable<String?>("")

    private var lock = false
    private var lastRequest: DataRequest?

    override func prepare() {
        query.observeNext { [unowned self] query in
            self.search(query ?? "")
        }.dispose(in: bag)
    }

    private func search(_ query: String) {
        page.value = 1
        lastRequest?.cancel()
        lastRequest = ReClient.shared.getSearch(query: query, page: page.value) { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
            case .success(let model):
                self.setState(.done)
                self.content.replace(with: model.content)
            }
        }
    }

    func loadNext() {
//        page.value += 1
//        ReClient.shared.getSearch(query: query.value, page: page.value) { result in
//            switch result {
//            case .failure(let error):
//                self.setState(.failed(error))
//                break
//            case .success(let model):
//                self.setState(.done)
//
//                var temp = self.content.collection
//                temp.append(contentsOf: model.content)
//                self.content.replace(with: temp)
//                break
//            }
//        }
    }
}
