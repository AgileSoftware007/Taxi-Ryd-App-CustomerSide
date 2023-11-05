//
//  TripDetailsVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 27/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class TripDetailsVC: UIViewController {
    
    var objPastTripResponse : Trip?

    @IBOutlet weak var lblTripDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFromLocation: UILabel!
    @IBOutlet weak var lblToLocation: UILabel!
    @IBOutlet weak var lblVehicleInfo: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblWaitTime: UILabel!
    @IBOutlet weak var lblSchTime: UILabel!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // addBackButton(str: "")
        setData()
    }
    
    
    func setData(){
        lblTripDate.text = objPastTripResponse?.created
        lblAmount.text = "$" + /objPastTripResponse?.customerTotal
        lblFromLocation.text = objPastTripResponse?.pickupAddress
        lblToLocation.text = objPastTripResponse?.toAddress
        lblVehicleInfo.text = /objPastTripResponse?.vehicleBrand + " " + /objPastTripResponse?.vehicleModel
        lblCost.text = "$" + String(format: "%.2f", /objPastTripResponse?.charges?.perMile)
        lblWaitTime.text = "$" + String(format: "%.2f", /objPastTripResponse?.charges?.waitTime)
        lblSchTime.text = "$" + String(format: "%.2f", /objPastTripResponse?.charges?.waitTime)
        lblTip.text = "$" + /objPastTripResponse?.charges?.tip
        lblTotal.text = "$" + /objPastTripResponse?.customerTotal
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
