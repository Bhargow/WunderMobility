//
//  WunderMobilityCoreDataManagerTests.swift
//  WunderMobilityTests
//
//  Created by rao on 16/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest
@testable import WunderMobility

class WunderMobilityCoreDataManagerTests: XCTestCase {

    var coredataManager: WMCoreDataManager!
    var carListData: [[String : Any]]!
    
    override func setUp() {
        coredataManager = WMCoreDataManager.sharedInstance
        carListData = getCarListData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveSingleData() {
        coredataManager.clearDatabase()
        guard let data = carListData.first else {
            return
        }
        coredataManager.saveOrUpdateDataToDB(jsonData: [data], success: {
            let carList = self.coredataManager.fetchCarListData()
            XCTAssertEqual(1, carList.count)
            let car = carList[0]
            XCTAssertEqual("\(data["name"] ?? "")", car.name)
            XCTAssertEqual("\(data["engineType"] ?? "")", car.engineType)
            XCTAssertEqual("\(data["exterior"] ?? "")", car.exterior)
            
            let fuel = (data["fuel"] as? Int16) ?? 0
            
            XCTAssertEqual(fuel, car.fuel)
            XCTAssertEqual("\(data["interior"] ?? "")", car.interior)
            XCTAssertEqual("\(data["vin"] ?? "")", car.vin)
            
            let lat = ((data["coordinates"] as? [Double])?[1]) ?? 0.0
            let long = ((data["coordinates"] as? [Double])?[0]) ?? 0.0
            
            XCTAssertEqual(long, car.coordinates?.longitude ?? 0.0)
            XCTAssertEqual(lat, car.coordinates?.lattitude ?? 0.0)
        }) { (error) in
            XCTFail(error)
        }
    }
    
    func testSaveMultipleData() {
        coredataManager.clearDatabase()
        
        var dataToSave:[[String : Any]] = []
        for i in 0...10 {
            dataToSave.append(carListData[i])
        }
        coredataManager.saveOrUpdateDataToDB(jsonData: dataToSave, success: {
            for data in dataToSave {
                let filteredDataObjects = self.coredataManager.fetchCarData(for: "\(data["vin"] ?? "")")
                XCTAssertEqual(filteredDataObjects.count, 1)
            }
        }) { (error) in
            XCTFail(error)
        }
    }
    
    func testDeleteCarData() {

        var dataToSave:[[String : Any]] = []
        for i in 0...10 {
            dataToSave.append(carListData[i])
        }
        coredataManager.saveOrUpdateDataToDB(jsonData: dataToSave, success: {
            let carList = self.coredataManager.fetchCarListData()
                XCTAssertEqual(dataToSave.count, carList.count)
        }) { (error) in
            XCTFail(error)
        }
        
        let carList = self.coredataManager.fetchCarListData()
        XCTAssertTrue(coredataManager.deleteCarFromData(carList.first!))
        
        let filteredDataObjects = self.coredataManager.fetchCarData(for: "\(carList.first!.vin ?? "")")
        XCTAssertEqual(filteredDataObjects.count, 0)
    }
    
    func getCarListData() -> [[String : Any]] {
        var carListData: [[String : Any]] = []
        
        if let path = Bundle(for: type(of: self)) .path(forResource: "TempCarDataForTesting", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let placemarks = json["placemarks"] as? [[String : Any]] {
                        for dict in placemarks {
                            carListData.append(dict)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return carListData
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
