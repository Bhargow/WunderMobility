//
//  WMCarDetailsTableViewCell.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class WMCarDetailsTableViewCell: UITableViewCell {

    @IBOutlet var name          : UILabel!
    @IBOutlet var engineType    : UILabel!
    @IBOutlet var address       : UILabel!
    @IBOutlet var shadowView    : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    - Description: Set up shadow
//    - Parameters: None
//    - Returns: Void
    private func setupShadow() {
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }

//    - Description: Set up cell data
//    - Parameters: data: WMCarDetailsModel
//    - Returns: Void
    func setUpCell(with data: WMCarDetailsModel) {
        name.text = data.name
        engineType.text = data.engineType
        address.text = data.address
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                name.textColor = UIColor.black
                engineType.textColor = UIColor.black
                address.textColor = UIColor.black
                shadowView.backgroundColor = UIColor.white
            }
        }
        self.setupShadow()
    }
}
