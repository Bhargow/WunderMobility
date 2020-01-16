//
//  WMCarDetailsModel+CoreDataClass.swift
//  
//
//  Created by rao on 14/01/20.
//
//

import Foundation
import CoreData

@objc(WMCarDetailsModel)
public class WMCarDetailsModel: NSManagedObject {

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?, data: [String : Any]) {
        super.init(entity: entity, insertInto: context)
            
        self.setValue(data["name"],         forKey: "name")
        self.setValue(data["vin"],          forKey: "vin")
        self.setValue(data["address"],      forKey: "address")
        self.setValue(data["engineType"],   forKey: "engineType")
        self.setValue(data["exterior"],     forKey: "exterior")
        self.setValue(data["fuel"],         forKey: "fuel")
        self.setValue(data["interior"],     forKey: "interior")
    }
    
//    - Description: Updates existing data model
//    - Parameters: data: [String : Any]]
//    - Returns: Void
    func updateData(data: [String : Any]) {
        if let name = (data["name"] as? String) {
            self.name = name
        }
        if let address = (data["address"] as? String) {
            self.address = address
        }
        if let engineType = (data["engineType"] as? String) {
            self.engineType = engineType
        }
        if let exterior = (data["exterior"] as? String) {
            self.exterior = exterior
        }
        if let fuel = (data["fuel"] as? Int16) {
            self.fuel = fuel
        }
        if let interior = (data["interior"] as? String) {
            self.interior = interior
        }
        if let coordinates = data["coordinates"] as? [Double] {
            self.coordinates?.lattitude = coordinates[0]
            self.coordinates?.longitude = coordinates[1]
        }
    }
    
//    - Description: Get lattitude from json dictionary
//    - Parameters: corrdinatesArray: [Double]
//    - Returns: Double
    func getLat(corrdinatesArray: [Double]?) -> Double? {
        return corrdinatesArray?[0] ?? nil
    }

//    - Description: Get lattitude from json dictionary
//    - Parameters: corrdinatesArray: [Double]
//    - Returns: Double
    func getLong(corrdinatesArray: [Double]?) -> Double? {
        return corrdinatesArray?[1] ?? nil
    }
}
