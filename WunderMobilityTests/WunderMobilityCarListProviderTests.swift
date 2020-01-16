//
//  WunderMobilityCarListProviderTests.swift
//  WunderMobilityTests
//
//  Created by rao on 16/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest
@testable import WunderMobility

class WunderMobilityCarListProviderTests: XCTestCase {

    private var apiManager: WMAPIManager!
    
    override func setUp() {
        apiManager = WMAPIManager(sessionObj: URLSession.shared)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCarListProviderCorrectURL() {
        let excepection = XCTestExpectation.init(description: "Car List Provider Correct URL")
        let carListProvider = WMCarListProvider.init(urlString: defaultUrlString, apiManagerObj: apiManager, coreDataManagerObject: WMCoreDataManager.sharedInstance)
        carListProvider.getCarsList(success: { (result) in
            XCTAssertNotNil(result)
            XCTAssertTrue(result.count > 0)
            excepection.fulfill()
        }) { (error) in
            XCTFail("\(error)")
            excepection.fulfill()
        }
        wait(for: [excepection], timeout: 10)
    }
    
    func testCarListProviderWrongURL() {
        let excepection = XCTestExpectation.init(description: "Car List Provider Wrong URL")
        let wrongURLString = "https://google.com"
        let carListProvider = WMCarListProvider.init(urlString: wrongURLString, apiManagerObj: apiManager, coreDataManagerObject: WMCoreDataManager.sharedInstance)
        carListProvider.getCarsList(success: { (result) in
            XCTFail("Response for wrong URL")
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
