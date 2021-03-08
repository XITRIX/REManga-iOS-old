//
//  CollectionViewModel.swift
//  REManga
//
//  Created by Daniil Vinogradov on 08.03.2021.
//

import Foundation
import Bond

class CollectionViewModel: BaseViewModel {
    let page = Observable<Int>(1)
    let content = MutableObservableCollection<[ReCatalogContent]>([])
    
    private var loadLock = false
    
    required init() {
        super.init()
        
        loadNext { result in
            switch result {
            case .failure(let error):
                self.setState(.failed(error))
                break
            case .success(_):
                self.setState(.done)
                break
            }
        }
        
    }
    
    func loadNext(completionHandler: ((Result<ReCatalogModel, Error>) -> ())? = nil) {
        if loadLock { return }
        
        loadLock = true
        ReClient.shared.getCatalog(page: page.value, count: 30) { result in
            switch result {
            case .failure(_):
                break
            case .success(let model):
                self.setModel(model)
                self.page.value += 1
                break
            }
            completionHandler?(result)
            self.loadLock = false
        }
    }
    
    func setModel(_ model: ReCatalogModel) {
        var temp = content.collection
        temp.append(contentsOf: model.content)
        content.replace(with: temp)
    }
}
