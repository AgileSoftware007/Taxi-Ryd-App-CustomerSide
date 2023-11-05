//
//  AddBankAccountVC.swift
//  DriverApp
//
//  Created by Prepladder on 22/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import SDWebImage

class AddBankAccountVC: BaseVC {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var txtRoutingNumber: ACFloatingTextfield!
    @IBOutlet weak var txtVerifyRoutingNumber: ACFloatingTextfield!
    @IBOutlet weak var txtAccountNumber: ACFloatingTextfield!
    @IBOutlet weak var txtVerifyAccountNumber: ACFloatingTextfield!
    var objLoginResponse : LoginResponse??
    var objApimanager = ApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton(str: "")
        addTapGesture()
        //setData()
    }
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
        self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    
    @IBAction func applyBtnAction(_ sender: Any) {
        
    }
    
    @objc func setData(){
//        self.lblFirstName.text = self.objOTPAuthResponse?.user?.firstName?.capitalized
//        self.lblLastName.text = self.objOTPAuthResponse?.user?.lastName?.capitalized
//        self.lblDate.text = self.objOTPAuthResponse?.user?.created
        let imgUrl = objApimanager.BASE_URL + /self.objLoginResponse??.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddBankAccountVC {
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
}
