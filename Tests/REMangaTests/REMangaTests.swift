//
//  REMangaTests.swift
//  REMangaTests
//
//  Created by Daniil Vinogradov on 20.02.2021.
//

import XCTest
import Alamofire
@testable import REManga

class REMangaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testApiCurrent() throws {
        let client = ReClient()
        let expect = expectation(description: "ReClient gets title and runs the callback closure")

        client.getCurrent { result in
            switch result {
            case .success(let model):
                print(model)
                break
            case .failure(let error):
                XCTFail("Error getting title: \(error)")
                break
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testApiSetViews() throws {
        let client = ReClient()
        let expect = expectation(description: "ReClient gets title and runs the callback closure")

        client.setViews(chapter: 326824) { result in
            switch result {
            case .success(let model):
                if model == "\"ok\"" {
                    expect.fulfill()
                    return
                }
                XCTFail("Error getting Views: \(model)")
                break
            case .failure(let error):
                XCTFail("Error getting title: \(error)")
                break
            }
        }

        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testApiTitle() throws {
        let client = ReClient()
        let expect = expectation(description: "ReClient gets title and runs the callback closure")

        client.getTitle(title: "solo-leveling") { result in
            switch result {
            case .success(let model):
                print(model)
                break
            case .failure(let error):
                XCTFail("Error getting title: \(error)")
                break
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testApiSearch() throws {
        let client = ReClient()
        let expect = expectation(description: "ReClient gets search query and runs the callback closure")

        client.getSearch(query: "Начало после", page: 1, count: 30) { result in
            switch result {
            case .success(let model):
                print(model)
                break
            case .failure(let error):
                XCTFail("Error getting title: \(error)")
                break
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
