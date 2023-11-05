//
//  UIButton+Extensions.swift
//
//  Created by Apple on 23/08/18.
//  Copyright © 2018 Sandeep. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func loadingIndicator(_ show: Bool, view: UIView) {
        
        let tag = 808404
        let text = self.titleLabel?.text
        if show {
            
            self.setTitle("", for: .normal)
            view.isUserInteractionEnabled = false
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
            
        } else {
            
            self.setTitle(text, for: .normal)
            view.isUserInteractionEnabled = true
            self.isEnabled = true
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
}
    
    
}

extension UIViewController {
    func makeborder(sender: UIButton){
           sender.layer.cornerRadius = 12
           sender.layer.masksToBounds = true
           sender.layer.borderWidth = 2.0
           sender.layer.borderColor = UIColor.white.cgColor
       }
    
    func addBackButton(str: String) {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  Asset.NdBackBtn.rawValue), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.white
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("   " + str, for: .normal)
        backButton.tintColor = UIColor.appColor
        backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    func addWebBackButton(text: String) {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  Asset.NdBackBtn.rawValue), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.white
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("   " + text, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 20)
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
    
    
    
    @objc func backAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    
}
