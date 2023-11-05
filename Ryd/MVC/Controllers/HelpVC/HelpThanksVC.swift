//
//  HelpThanksVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 24/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class HelpThanksVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    var msgStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       // addBackButton(str: "")
        self.navigationController?.navigationBar.isHidden = true
      //  self.lblDesc.text = msgStr
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    
}
