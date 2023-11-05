//
//  CompleteRegistrationVC.swift
//  DriverApp
//
//  Created by Harsh on 12/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class CompleteRegistrationVC: UIViewController {

    @IBOutlet weak var lblCompleteText: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgVwCompelte: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.addBackButton()
        makeborder(sender: btnClose)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.viewControllers.remove(at: 0)
        let vc = ViewController.getVC(.main)
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    

}

extension CompleteRegistrationVC {
    @objc func addBackButton() {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  Asset.NdBackBtn.rawValue), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.appColor
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("" , for: .normal)
        backButton.tintColor = UIColor.white
        backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.appColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.appColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.appColor
    }
}
