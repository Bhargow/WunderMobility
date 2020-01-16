//
//  WMCarDetailsModel+CoreDataProperties.swift
//  
//
//  Created by rao on 15/01/20.
//
//

import Foundation
import CoreData


extension WMCarDetailsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WMCarDetailsModel> {
        return NSFetchRequest<WMCarDetailsModel>(entityName: "WMCarDetailsModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var vin: String?
    @NSManaged public var address: String?
    @NSManaged public var engineType: String?
    @NSManaged public var exterior: String?
    @NSManaged public var fuel: Int16
    @NSManaged public var interior: String?
    @NSManaged public var coordinates: WMCarCoordinatesModel?

}
