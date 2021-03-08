//
//  ReClient.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Foundation
import Alamofire

class ReClient {
    static let baseUrl = "https://api.remanga.org/"
    
    static let shared = ReClient()
    
    func getTitle(title: String, completionHandler: @escaping (Result<ReTitleModel, Error>) -> ()) {
        let api = "api/titles/" + title
        baseRequest(api, completionHandler: completionHandler)
    }
    
    func getBranch(branch: Int, completionHandler: @escaping (Result<ReBranchModel, Error>) -> ()) {
        let api = "api/titles/chapters/?branch_id=" + String(branch)
        baseRequest(api, completionHandler: completionHandler)
    }
    
    func getSimilar(title: String, completionHandler: @escaping (Result<ReSimilarModel, Error>) -> ()) {
        let api = "api/titles/" + title + "/similar"
        baseRequest(api, completionHandler: completionHandler)
    }
    
    func getChapter(chapter: Int, completionHandler: @escaping (Result<ReChapterModel, Error>) -> ()) {
        let api = "api/titles/chapters/\(chapter)/"
        baseRequest(api, completionHandler: completionHandler)
    }
    
    func getCatalog(page: Int, count: Int = 30, completionHandler: @escaping (Result<ReCatalogModel, Error>) -> ()) {
        let api = "api/search/catalog/?ordering=-rating&page=\(page)&\(count)"
        baseRequest(api, completionHandler: completionHandler)
    }
    
    func baseRequest<T: Decodable>(_ api: String, completionHandler: @escaping (Result<T, Error>) -> ()) {
        AF.request(ReClient.baseUrl + api, method: .get, encoding: URLEncoding.default).responseData { response in
            switch response.result {
            case .success(let res):
                do {
                    let title = try JSONDecoder().decode(T.self, from: res)
                    completionHandler(.success(title))
                    print(title)
                } catch {
                    completionHandler(.failure(error))
                    print(error)
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
