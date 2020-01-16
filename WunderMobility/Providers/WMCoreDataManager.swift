//
//  WMCoreDatatManager.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import CoreData

class WMCoreDataManager {
    
    private var managedContext: NSManagedObjectContext!
    
    static let sharedInstance: WMCoreDataManager = {
        let coreDataManager = WMCoreDataManager()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let mainManagedObjectContext = appDelegate?.persistentContainer.viewContext
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        coreDataManager.managedContext = privateManagedObjectContext
        return coreDataManager
    }()
    

    //    - Description: Save response data to Core Data
    //    - Parameters: data: [String : Any], success: completionBlock, errorOccured: errorBlock
    //    - Returns: Void
    func saveOrUpdateDataToDB(jsonData: [[String : Any]], success: @escaping () -> Void, errorOccured: @escaping (_ error: String) -> Void) {
        
        let carDetailsEntityDescription = NSEntityDescription.entity(forEntityName: "WMCarDetailsModel", in: managedContext)!
        let fetchCarDetailsFetchRequest: NSFetchRequest<WMCarDetailsModel> = WMCarDetailsModel.fetchRequest()
        
        func createNewData(_ data : [String : Any]) {
            let carDetailsModel = WMCarDetailsModel.init(entity: carDetailsEntityDescription, insertInto: managedContext, data: data)
            if let coordinates = data["coordinates"] as? [Double] {
                let carCoordinatesEntityDescription = NSEntityDescription.entity(forEntityName: "WMCarCoordinatesModel", in: managedContext)!
                carDetailsModel.coordinates = WMCarCoordinatesModel.init(entity: carCoordinatesEntityDescription, insertInto: managedContext, data: coordinates)
            }
        }
        
        for data in jsonData {
            if let vin = data["vin"] as? String {
                fetchCarDetailsFetchRequest.predicate = NSPredicate(format: "vin == %@", vin)
                do {
                    let fetchedCarDetailsManagedContext = try managedContext.fetch(fetchCarDetailsFetchRequest)
                    if fetchedCarDetailsManagedContext.count > 0 {
                        if let carDetail = fetchedCarDetailsManagedContext.first {
                            carDetail.updateData(data: data)
                        }
                    } else {
                        createNewData(data)
                    }
                } catch {
                    errorOccured("Failed to fetch data: \(error)")
                }
            }
        }
        
        do {
            try managedContext.save()
            success()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            errorOccured("\(error.localizedDescription)")
        }
    }
    
    //    - Description: Fetch car list
    //    - Parameters: None
    //    - Returns: [CurrencyConversions]
    func fetchCarListData() -> [WMCarDetailsModel] {
        let fetchCurrencyPairsFetchRequest: NSFetchRequest<WMCarDetailsModel> = WMCarDetailsModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "name", ascending: true)
        fetchCurrencyPairsFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let fetchedCurrencyPairs = try  managedContext.fetch(fetchCurrencyPairsFetchRequest)
            return fetchedCurrencyPairs
        } catch {
            return []
        }
    }

    //    - Description: Fetch car list for vin
    //    - Parameters: vin: String
    //    - Returns: [CurrencyConversions]
    func fetchCarData(for vin: String) -> [WMCarDetailsModel] {
        let fetchCurrencyPairsFetchRequest: NSFetchRequest<WMCarDetailsModel> = WMCarDetailsModel.fetchRequest()
        let vinFilter = NSPredicate(format: "vin == %@", vin)
        fetchCurrencyPairsFetchRequest.predicate = vinFilter
        do {
            let fetchedCurrencyPairs = try  managedContext.fetch(fetchCurrencyPairsFetchRequest)
            return fetchedCurrencyPairs
        } catch {
            return []
        }
    }
    
    //    - Description: Delete just one car detail
    //    - Parameters: object: WMCarDetailsModel
    //    - Returns: Void
    func deleteCarFromData(_ object: WMCarDetailsModel) -> Bool {
        managedContext.delete(object)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    //    - Description: Clear database for testing
    //    - Parameters: None
    //    - Returns: Void
    func clearDatabase() {
        // create the delete request for the specified entity
        let carDetailsFetchRequest: NSFetchRequest<NSFetchRequestResult> = WMCarDetailsModel.fetchRequest()
        let carCoordinatesfetchRequest: NSFetchRequest<NSFetchRequestResult> = WMCarCoordinatesModel.fetchRequest()
        
        let deleteCarDetailsRequest = NSBatchDeleteRequest(fetchRequest: carDetailsFetchRequest)
        let deleteCarCoordinatesRequest = NSBatchDeleteRequest(fetchRequest: carCoordinatesfetchRequest)

        // get reference to the persistent container
        // perform the delete
        do {
            try managedContext.execute(deleteCarDetailsRequest)
            try managedContext.execute(deleteCarCoordinatesRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}

