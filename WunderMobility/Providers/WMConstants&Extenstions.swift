//
//  File.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation
import UIKit
import MapKit

var defaultUrlString: String = "https://wunder-test-case.s3-eu-west-1.amazonaws.com/ios/locations.json"
let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050)
//Hamburg
let defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937), span: defaultSpan)

extension UIViewController {
    
    //    - Description: Presents alert view controller after checking if there are any other alert controllers in the view herirarchy
    //    - Parameters: message: String, btnTitleOne: String, btnTitleTwo: String (Can be nil), completionOk: Action Block (Can be nil), cancel: Action Block (Can be nil), title: String? = nil)
    //    - Returns: Void
    func showAlertViewWithBlock(message: String,btnTitleOne: String, btnTitleTwo: String? = "", completionOk: (() -> Void)? = nil, cancel:(() -> Void)? = nil, title: String? = nil) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: btnTitleOne, style: .default, handler: { (alertAction) -> Void in
            if let completionBlock = completionOk {
                completionBlock()
            }
        }))
        
        if !"\(btnTitleTwo ?? "")".isEmpty {
            alertView.addAction(UIAlertAction(title: btnTitleTwo, style: .cancel, handler: { (alertAction) -> Void in
                if let cancelBlock = cancel {
                    cancelBlock()
                }
            }))
            
        }
        
        if self.presentedViewController == nil {
            DispatchQueue.main.async {
                self.present(alertView, animated: true, completion: nil)
            }
        } else {
            // Either the Alert is already presented, or any other view controller is active
            let thePresentedVC : UIViewController? = self.presentedViewController as UIViewController?
            if thePresentedVC != nil {
                if let _ : UIAlertController = thePresentedVC as? UIAlertController {
                    // Nothing to do , AlertController already active
                    print("Alert not necessary, already on the screen !")
                } else {
                    // There is another ViewController presented but it is not an UIAlertController, so do your UIAlertController-Presentation with this presented ViewController
                    DispatchQueue.main.async {
                        self.present(alertView, animated: true, completion: nil)
                    }
                    print("Alert comes up via another presented VC, e.g. a PopOver")
                }
            }
        }
    }
}
