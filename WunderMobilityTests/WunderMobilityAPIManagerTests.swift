//
//  WunderMobilityTests.swift
//  WunderMobilityTests
//
//  Created by rao on 14/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest
@testable import WunderMobility

class WunderMobilityTests: XCTestCase {

    private var apiManager: WMAPIManager!
    
    override func setUp() {
        apiManager = WMAPIManager(sessionObj: URLSession.shared)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApiManagerCorrectURL() {
        let excepection = XCTestExpectation(description: "Api Manager Request Correct URL")
        apiManager.request(urlString: defaultUrlString, httpMethod: .get, params: nil, completion: { (response) in
            XCTAssertNotNil(response)
            excepection.fulfill()
        }) { (error) in
            XCTFail("\(error)")
            excepection.fulfill()
        }
        wait(for: [excepection], timeout: 10)
    }
    
    func testApiManagerWrongURL() {
        let wrongURLString = "https://google.com"
        
        let excepection = XCTestExpectation.init(description: "Api Manager Request Wrong URL")
        apiManager?.request(urlString: wrongURLString, httpMethod: .get, params: nil, completion: { (response) in
            XCTFail("Reesponse for wrong URL")
            excepection.fulfill()
        }) { (error) in
            XCTAssertNotNil(error)
            excepection.fulfill()
        }
        wait(for: [excepection], timeout: 10)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
