//
//  WunderMobilityCarListPresenterTests.swift
//  WunderMobilityTests
//
//  Created by rao on 16/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest
@testable import WunderMobility

class WunderMobilityCarListPresenterTests: XCTestCase {

    var carListPresenter: WMCarListPresenter!
    var presenterDelegateExpectations: XCTestExpectation = XCTestExpectation(description: "Wunder Mobility Car List Presenter Delegate Tests")
    
    override func setUp() {
        carListPresenter = WMCarListPresenter.init(delegateObj: self, coreDataManagerObj: WMCoreDataManager.sharedInstance)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCarListDataFromDB() {
        carListPresenter.getCarListDataFromCoreData()
        wait(for: [presenterDelegateExpectations], timeout: 10)
    }
    
    func testGetCarListDataFromApi() {
        carListPresenter.getCarListDataFromApi()
        wait(for: [presenterDelegateExpectations], timeout: 10)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension WunderMobilityCarListPresenterTests: WMCarListPresenterDelegate {
    func loadedDataSuccessfully(_ carListData: [WMCarDetailsModel]) {
        XCTAssertTrue(carListData.count > 0)
        presenterDelegateExpectations.fulfill()
    }
    
    func errorOccoured(_ errorMessage: String) {
        XCTAssertNotNil(errorMessage)
        presenterDelegateExpectations.fulfill()
    }
}
