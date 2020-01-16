//
//  WMInternetConnectionManager.swift
//  WunderMobility
//
//  Created by rao on 14/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import Reachability

class WMInternetConnectionManager {
    
    static var sharedInstance = WMInternetConnectionManager()
    var reachablity: Reachability
    
    init(reachablityObj: Reachability = Reachability.init()) {
        reachablity =  reachablityObj
    }
    
    //    - Description: Reachability manager Starts monitoring for network disconnections and re-connections
    //    - Parameters: None
    //    - Returns: Void
    func startNetworkConnectionMonitoring() {
        reachablity.startNotifier()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: .reachabilityChanged,
            object: reachablity
        )
    }
    
    //    - Description: Reachability manager updates for network disconnections and re-connections
    //    - Parameters: None
    //    - Returns: Void
    @objc func networkStatusChanged() {
        switch reachablity.currentReachabilityStatus() {
        case .NotReachable:
            print("Unavailable")
            NotificationCenter.default.post(name: NSNotification.Name("networkConnectivityChanged"), object: false)
        default:
            NotificationCenter.default.post(name: NSNotification.Name("networkConnectivityChanged"), object: true)
        }
    }
}
