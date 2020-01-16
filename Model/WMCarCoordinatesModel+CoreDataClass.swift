//
//  WMCarCoordinatesModel+CoreDataClass.swift
//  
//
//  Created by rao on 14/01/20.
//
//

import Foundation
import CoreData

@objc(WMCarCoordinatesModel)
public class WMCarCoordinatesModel: NSManagedObject {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?, data: [Double]) {
        super.init(entity: entity, insertInto: context)
        self.setValue(data[0], forKey: "longitude")
        self.setValue(data[1], forKey: "lattitude")
    }
}
