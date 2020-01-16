//
//  WMCarListPresenter.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation
import MapKit

protocol WMCarListPresenterDelegate {
    func loadedDataSuccessfully(_ carListData: [WMCarDetailsModel])
    func errorOccoured(_ errorMessage: String)
}

class WMCarListPresenter: NSObject {
    var delegate: WMCarListPresenterDelegate!
    var coreDataManager: WMCoreDataManager!
    
    init(delegateObj: WMCarListPresenterDelegate, coreDataManagerObj: WMCoreDataManager = WMCoreDataManager.sharedInstance) {
        delegate = delegateObj
        coreDataManager = coreDataManagerObj
    }
    
//    - Description: Get carList data from local database
//    - Parameters: None
//    - Returns: Void
    func getCarListDataFromCoreData() {
        let carListData = coreDataManager.fetchCarListData()
        if carListData.count > 0 {
            self.delegate.loadedDataSuccessfully(carListData)
        }
    }
    
//    - Description: Get carList data from API
//    - Parameters: None
//    - Returns: Void
    func getCarListDataFromApi() {
        WMCarListProvider().getCarsList(success: { (carListData) in
            DispatchQueue.main.async {
                self.delegate.loadedDataSuccessfully(carListData)
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.delegate.errorOccoured("\(error)")
            }
        }
    }
    
//    - Description: Get default region to Hamburg
//    - Parameters: None
//    - Returns: MKCoordinateRegion
    func getDefaultRegionForMap() -> MKCoordinateRegion {
        return defaultRegion
    }
    
//    - Description: Get selected table view car data for showing annotation
//    - Parameters: mapView: MKMapView, selectedCarDetails: WMCarDetailsModel
//    - Returns: MKAnnotation
    func getSelectedAnnotation(_ mapView: MKMapView, selectedCarDetails: WMCarDetailsModel) -> MKAnnotation? {
        if let annotations = mapView.annotations as? [WMAnnotation] {
            let selectedAnnotation = annotations.filter { (annotation) -> Bool in
                return annotation.carDetails.vin == selectedCarDetails.vin
            }
            
            if selectedAnnotation.count > 0, let annotationToBeSelected = selectedAnnotation.first {
                return annotationToBeSelected
            }
        }
        return nil
    }
    
//    - Description: Delete car model
//    - Parameters: carModel: WMCarDetailsModel
//    - Returns: Void
    func deleteCar(_ carModel : WMCarDetailsModel) {
        _ = coreDataManager.deleteCarFromData(carModel)
    }
}
