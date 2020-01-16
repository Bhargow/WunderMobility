//
//  WMAnnotation.swift
//  WunderMobility
//
//  Created by rao on 16/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import MapKit

class WMAnnotation : MKPointAnnotation {
    let carDetails: WMCarDetailsModel!
    init(with carDetailsModel: WMCarDetailsModel) {
        carDetails = carDetailsModel
    }
}
