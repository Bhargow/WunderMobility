//
//  WMMapViewController.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import MapKit

class WMDetailedMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var carListpresenter : WMCarListPresenter!
    var carList: [WMCarDetailsModel] = [] {
        didSet {
            loadMapViewAnnotations()
        }
    }
    var selectedCarDetailModel: WMCarDetailsModel?
    
// MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        carListpresenter = WMCarListPresenter(delegateObj: self)
        carListpresenter.getCarListDataFromCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Map view"
        setUpMapView()
    }
    
//    - Description: Set Up MapView with Selected Car DetailModel or default location to Hamburg
//    - Parameters: None
//    - Returns: Void
    func setUpMapView() {
        if let selectedCarDetails = selectedCarDetailModel {
            if let annotation = carListpresenter.getSelectedAnnotation(mapView, selectedCarDetails: selectedCarDetails) {
                mapView.selectAnnotation(annotation, animated: true)
            }
        } else {
            mapView.setRegion(carListpresenter.getDefaultRegionForMap(), animated: true)
        }
    }
    
//    - Description: Set Up MapView with annotations with available Car List
//    - Parameters: None
//    - Returns: Void
    func loadMapViewAnnotations() {
        for car in carList {
            let annotation = WMAnnotation(with: car)
            annotation.coordinate = CLLocationCoordinate2D(latitude: car.coordinates?.lattitude ?? 0.0, longitude: car.coordinates?.longitude ?? 0.0)
            annotation.title = car.name
            annotation.subtitle = car.address
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: MapView Delegate Methods
extension WMDetailedMapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "carAnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "carAnnotationView")
        }
        annotationView?.image = UIImage(named: "icn_CarForMap")
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation : MKAnnotation = view.annotation {
            let location: CLLocationCoordinate2D = annotation.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: Car List Presenter Delegate Methods
extension WMDetailedMapViewController : WMCarListPresenterDelegate {
    func loadedDataSuccessfully(_ carListData: [WMCarDetailsModel]) {
        carList = carListData
    }
    
    func errorOccoured(_ errorMessage: String) {
        self.showAlertViewWithBlock(message: errorMessage, btnTitleOne: "Ok")
    }
}
