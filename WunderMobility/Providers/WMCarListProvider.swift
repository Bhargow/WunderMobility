//
//  WMCarListProvider.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import CoreData

class WMCarListProvider: NSObject {
    
    private var apiManager: WMAPIManager!
    private var coreDataManager: WMCoreDataManager!
    private var URL = ""
    
    init(urlString: String = defaultUrlString, apiManagerObj: WMAPIManager = WMAPIManager(), coreDataManagerObject: WMCoreDataManager = WMCoreDataManager.sharedInstance) {
        apiManager = apiManagerObj
        coreDataManager = coreDataManagerObject
        URL = urlString
    }
    
    //    - Description: Fetches car list data from API
    //    - Parameters: pairs: [String], success: completionBlock, errorOccured: errorBlock
    //    - Returns: Void
    func getCarsList(success: @escaping (_ carListData: [WMCarDetailsModel]) -> Void, errorOccured: @escaping (_ error: APIManagerError) -> Void) {
        let url: String = URL
        apiManager.request(urlString: url, httpMethod: .get, params: nil, completion: { (response) in
            if let placemarks = ((response as! [String : Any])["placemarks"]) as? [[String: Any]] {
                self.coreDataManager.saveOrUpdateDataToDB(jsonData: placemarks, success: {
                    success(self.coreDataManager.fetchCarListData())
                }) { (error) in
                    errorOccured(.InternalError("\nCould not save data."))
                }
            } else {
                errorOccured(.InvalidResponse("\nNo car details found."))
            }
        }) { (error) in
            print(error)
            errorOccured(.InvalidResponse("\n\(error.localizedDescription)"))
        }
    }
}
