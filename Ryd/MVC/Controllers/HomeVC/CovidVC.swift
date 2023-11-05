//
//  CovidVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 10/05/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

protocol OnlineUpdate : class {
    func onlinestatus()
}
class CovidVC: UIViewController {
    
    @IBOutlet weak var lblCompleteText: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgVwCompelte: UIImageView!
    weak var delegate: OnlineUpdate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // makeborder(sender: btnClose)
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.onlinestatus()
        }
    }
    
    
}

