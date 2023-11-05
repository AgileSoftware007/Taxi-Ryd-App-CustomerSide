//
//  UploadedDocumnet.swift
//  Ryd Driver
//
//  Created by Prepladder on 26/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class UploadedDocumnet: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeborder(sender: btnClose)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
