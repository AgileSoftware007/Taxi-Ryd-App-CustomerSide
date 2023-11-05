//
//  ForgotPasswordVC.swift
//  DriverApp
//
//  Created by Harsh on 09/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift


class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    var objApi = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // addBackButtonn()
        self.makeborder(sender: btnSave)
        txtPhoneNumber.delegate = self
        //txtPhoneNumber.becomeFirstResponder()
        // btnBack.setTitle("", for: .normal)
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    @IBAction func sendRequestAction(_ sender: Any) {
        if validation() {
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                let phoneStr = txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                callForgotPasswordApi(phoneNumberStr: phoneStr)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
}

extension ForgotPasswordVC: UITextFieldDelegate {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let phoneStr = txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if phoneStr == "" {
            txtPhoneNumber.showErrorWithText(errorText: AlertMessage.emptyPhoneNumber.localized)
            return false
        } else if phoneStr.count < 10{
            txtPhoneNumber.showErrorWithText(errorText: AlertMessage.invalidPhoneNumber.localized)
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
    
    
}

extension ForgotPasswordVC {
    
    func callForgotPasswordApi(phoneNumberStr: String){
        
        //let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "country_code": 1,
            "phonenumber": phoneNumberStr
        ] as [String : Any]
        
        print("Forgot Password PARAMS => ", params)
        
        
        self.objApi.forgotPassword(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(SignUpResponse.self, from: /response.data)
                    if loginResponse.status == true {
#if targetEnvironment(simulator)
                        let alert = UIAlertController(title: "Your Verification Code is", message: loginResponse.otp, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            let vc = VerificationCodeVC.getVC(.main)
                            vc.signUpResponse = loginResponse
                            vc.comesFrom = FORGOT
                            self.navigationController?.pushViewController(vc, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
#else
                        let vc = VerificationCodeVC.getVC(.main)
                        vc.signUpResponse = loginResponse
                        vc.comesFrom = FORGOT
                        self.navigationController?.pushViewController(vc, animated: true)
#endif
                        
                    }else {
                        print(/loginResponse.message)
                        self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom)
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                break
            case .failure(_):
                print("response.result.error ",response.result.error as Any)
                break
            }
            
        })
        
    }
}

extension ForgotPasswordVC {
    @objc func addBackButtonn() {
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
