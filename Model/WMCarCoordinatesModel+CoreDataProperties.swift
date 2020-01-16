//
//  WMCarCoordinatesModel+CoreDataProperties.swift
//  
//
//  Created by rao on 15/01/20.
//
//

import Foundation
import CoreData


extension WMCarCoordinatesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WMCarCoordinatesModel> {
        return NSFetchRequest<WMCarCoordinatesModel>(entityName: "WMCarCoordinatesModel")
    }

    @NSManaged public var lattitude: Double
    @NSManaged public var longitude: Double

}
