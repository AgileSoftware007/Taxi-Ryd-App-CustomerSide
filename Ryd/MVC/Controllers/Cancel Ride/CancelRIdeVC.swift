//
//  CancelRIdeVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 19/05/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

protocol RideCancelDelegate : class {
    func cancelRide()
}
class CancelRIdeVC: UIViewController {

    weak var delegate: RideCancelDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton(str: "")
    }
    

    @IBAction func cancelRiderAction(_ sender: Any) {
        delegate?.cancelRide()
        self.navigationController?.popToRootViewController(animated: false)
        
    }

}
