//
//  VerificationCodeVC.swift
//  DriverApp
//
//  Created by Harsh on 09/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SVPinView
import Toast_Swift
import MBProgressHUD

class VerificationCodeVC: UIViewController {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vwOTP: SVPinView!
    var comesFrom = ""
    var signUpResponse : SignUpResponse?
    var objApi = ApiManager()
    
    var objOTPResponse : OTPAuthResponse? {
        didSet{
            
        }
    }
    var objForgotPasswordVerify : ForgotPasswordVerify?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        self.makeborder(sender: self.btnSave)
       // addBackButton()
        otpViewSetUp()
        // vwOTP.becomeFirstResponderAtIndex = 0
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        print("vwOTP ",vwOTP.getPin())
    }
    
}

extension VerificationCodeVC {
    fileprivate func otpViewSetUp(){
        
        vwOTP.textColor = UIColor.white
        
        vwOTP.style = .underline
        
        vwOTP.keyboardType = .phonePad
        vwOTP.activeBorderLineColor = UIColor.white
        vwOTP.borderLineColor = UIColor.white
        vwOTP.activeBorderLineThickness = 3
        vwOTP.borderLineThickness = 1.5
        vwOTP.shouldSecureText = false
        
        vwOTP.didFinishCallback = { [weak self] pin in
            
            print("ENTERED PIN ",pin)
            if Reachability.isConnectedToNetwork(){
                if self?.comesFrom == FORGOT {
                    if self?.signUpResponse?.otp == pin {
                        MBProgressHUD.showAdded(to: /self?.view, animated: true)
                        self?.callForgotPasswordVerify(token: /self?.signUpResponse?.token, otp: /self?.signUpResponse?.otp)
                    } else {
                        print(AlertMessage.enterCorrectOtp.localized)
                        self?.view.makeToast(AlertMessage.enterCorrectOtp.localized, duration: 3.0, position: .top)
                    }
                }
                else {
                    if self?.signUpResponse?.otp == pin {
                        MBProgressHUD.showAdded(to: /self?.view, animated: true)
                        self?.callOTPAuth(token: /self?.signUpResponse?.token, otp: /self?.signUpResponse?.otp)
                    } else {
                        print(AlertMessage.enterCorrectOtp.localized)
                        self?.view.makeToast(AlertMessage.enterCorrectOtp.localized, duration: 3.0, position: .top)
                    }
                }
                
            }else {
                print(AlertMessage.noInternet.localized)
                self?.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
            
            
            
            
            
        }
        
        vwOTP.didChangeCallback = { [weak self] pin in
            print("Change PIN ",pin)
        }
    }
    
    func callOTPAuth(token: String, otp: String){
        
        let params = [
            "token": token,
            "otp": otp
        ] as [String : Any]
        
        print("OTP AUTH PARAMS => ", params)
        
        self.objApi.otpAuth(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(OTPAuthResponse.self, from: /response.data)
                    self.objOTPResponse = loginResponse
                    if self.objOTPResponse?.status == true {
                        BARRERTOKEN = /self.objOTPResponse?.user?.access?.token
                        UDManager.set(/self.objOTPResponse?.user?.access?.token, forKey: UDKeys.BEARER_TOKEN)
                        UDManager.synchronize()
                        if self.comesFrom == SIGNUP {
                            let vc = BasicInfoVC.getVC(.main)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }else {
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
    
    func callForgotPasswordVerify(token: String, otp: String){
        
        let params = [
            "token": token,
            "code": otp
        ] as [String : Any]
        
        print("FORGOT PASSWORD VERIFY PARAMS => ", params)
        
        self.objApi.forgotPaswordVerify(parameters: params, completion: { (response) in
            // hideActivityIndicator(view: self.view)
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(ForgotPasswordVerify.self, from: /response.data)
                    self.objForgotPasswordVerify = loginResponse
                    if self.objForgotPasswordVerify?.status == true {
                        let vc = UpdatePassword.getVC(.main)
                        vc.objForgotPasswordVerify = self.objForgotPasswordVerify
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
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

//extension VerificationCodeVC {
//    func homeVCRootViewController(){
//        self.navigationController?.viewControllers.remove(at: 0)
//        let vc = HomeVC.getVC(.main)
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    func basicInfoVCRootViewController(){
//        self.navigationController?.viewControllers.remove(at: 0)
//        let vc = BasicInfoVC.getVC(.main)
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    func addressRootViewController(){
//        self.navigationController?.viewControllers.remove(at: 0)
//        let vc = RegisterAddCardVC.getVC(.main)
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//}

extension VerificationCodeVC {
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
