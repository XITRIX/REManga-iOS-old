//
//  REMangaTests.swift
//  REMangaTests
//
//  Created by Daniil Vinogradov on 20.02.2021.
//

import XCTest
@testable import REManga

class REMangaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
