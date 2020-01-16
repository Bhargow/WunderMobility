//
//  ViewController.swift
//  WunderMobility
//
//  Created by rao on 14/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class WMCarListViewcontroller : UIViewController {
    @IBOutlet var tblViewCarList : UITableView!
    
    var carListpresenter : WMCarListPresenter!
    var carList: [WMCarDetailsModel] = [] {
        didSet {
            tblViewCarList.reloadData()
        }
    }
    
// MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        carListpresenter = WMCarListPresenter(delegateObj: self)
        carListpresenter.getCarListDataFromCoreData()
        carListpresenter.getCarListDataFromApi()
        
        // Handle darkmode interface style
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                tblViewCarList.backgroundColor = UIColor.white
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Car list"
    }
    
//    - Description: Switches To Map ViewController with seleted map data
//    - Parameters: object: WMCarDetailsModel
//    - Returns: Void
    func switchToMapViewController(with data: WMCarDetailsModel) {
        if let destinationViewController = self.tabBarController?.viewControllers?[1] as? WMDetailedMapViewController {
            destinationViewController.selectedCarDetailModel = data
            self.tabBarController?.selectedIndex = 1
        }
    }
}

// MARK: Tableview Delegate Methods
extension WMCarListViewcontroller : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = carList[indexPath.row]
        switchToMapViewController(with: cellData)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            carListpresenter.deleteCar(carList[indexPath.row])
            carList.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
}

// MARK: Tableview Datasource Methods
extension WMCarListViewcontroller : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            "WMCarDetailsTableViewCell", for: indexPath) as? WMCarDetailsTableViewCell {
            let cellData = carList[indexPath.row]
            cell.setUpCell(with: cellData)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: Car List Presenter Delegate Methods
extension WMCarListViewcontroller : WMCarListPresenterDelegate {
    func loadedDataSuccessfully(_ carListData: [WMCarDetailsModel]) {
        carList = carListData
    }
    
    func errorOccoured(_ errorMessage: String) {
        self.showAlertViewWithBlock(message: errorMessage, btnTitleOne: "Ok")
    }
}

