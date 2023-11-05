//
//  ViewController.swift
//  DriverApp
//
//  Created by Harsh on 07/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import Alamofire
import Toast_Swift
import MBProgressHUD

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNewRegister: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var vwEnglishLanguage: UIView!
    @IBOutlet weak var vwSpanishLanguage: UIView!
    var isExpand = false
    var englishSelected = true
    var objLoginResponse : LoginResponse?
    var objApi = ApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPhoneNumber.delegate = self
        txtPassword.delegate = self
        makeborder(sender: btnLogin)
        //  txtPhoneNumber.becomeFirstResponder()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        #if targetEnvironment(simulator)
        txtPhoneNumber.text = "4049928428"
        txtPassword.text = "Test@123"

//        txtPhoneNumber.text = "1234567890"
//        txtPassword.text = "Test@123"
        #endif
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
            
        let nameStr = txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordStr = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if nameStr == "" {
            txtPhoneNumber.showErrorWithText(errorText: AlertMessage.emptyPhoneNumber.localized)
        } else if nameStr.count < 10 {
            txtPhoneNumber.showErrorWithText(errorText: AlertMessage.invalidPhoneNumber.localized)
        }else if passwordStr == "" {
            txtPassword.showErrorWithText(errorText: AlertMessage.emptyPassword.localized)
        }else {
            if Reachability.isConnectedToNetwork(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.callLoginApi(nameStr: nameStr, passwordStr: passwordStr)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }

        }

        
    }
    
    
    
    @IBAction func forgotBtnAction(_ sender: Any) {
        let vc = ForgotPasswordVC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func newRegisterBtnAction(_ sender: Any) {
        let vc = RegisterVC.getVC(.main)
        //let vc = BasicInfoVC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func languageArrowBtnAction(_ sender: Any) {
        
        if !isExpand {
            UIView.animate(withDuration: 0.10, animations: {
                self.btnArrow.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            })
             self.vwSpanishLanguage.isHidden = false
            isExpand = true
        } else {
            UIView.animate(withDuration: 0.10, animations: {
                self.btnArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            })
            self.vwSpanishLanguage.isHidden = true
            isExpand = false
        }
    }
    
    @IBAction func englishLanguageBtnAction(_ sender: Any) {
        UIView.animate(withDuration: 0.10, animations: {
            self.btnArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
        })
        self.englishSelected = true
        self.vwSpanishLanguage.isHidden = true
    }
    
    @IBAction func spanishLanguageBtnAction(_ sender: Any) {
        UIView.animate(withDuration: 0.10, animations: {
            self.btnArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
        })
        self.englishSelected = false
        self.vwEnglishLanguage.isHidden = true
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
}


//MARK:- API CALL
extension ViewController {
    
    func callLoginApi(nameStr: String, passwordStr: String){
        let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "country_code": CountryCode,
            "phonenumber": nameStr,
            "password": passwordStr,
            "device_id": /DEVICE_ID,
            "device_type" : DEVICE_TYPE,
            "device_name" : DEVICE_NAME,
            "fcm_token": /token,
            "user_type" : USER_TYPE
        ] as [String : Any]
        
        print("LOGIN PARAMS => ", params)
        
        
        self.objApi.loginAPI(parameters: params, completion: { (response) in
            //hideActivityIndicator(view: self.view)
            MBProgressHUD.hide(for: self.view, animated: true)
//            print(response)
            print("LOGIN Response : ", response.data?.json ?? "")
//            print("LOGIN Response : ", response.data?.toDictionary() ?? [:])

            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: /response.data)
                    
                    if loginResponse.status == true {
                       // if loginResponse.user?.isVerified == "1"{
//                            print(loginResponse.user?.firstName)
//                            print(loginResponse.user?.addreses)
//                            print(loginResponse.user?.documents)
//                            print(loginResponse.user?.documents)
                            
                            BARRERTOKEN = /loginResponse.user?.access?.token
                            UDManager.set(/loginResponse.user?.access?.token, forKey: UDKeys.BEARER_TOKEN)
                            UDManager.synchronize()
                            if let encoded = try? JSONEncoder().encode(loginResponse) {
                                UDManager.set(encoded, forKey: UDKeys.LOGIN_INFO)
                                UDManager.synchronize()
                            }
                            
                            self.objLoginResponse = loginResponse
                            //print(self.objLoginResponse)
//                            if loginResponse.user?.firstName == nil {
//                                let vc = BasicInfoVC.getVC(.main)
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            } else if loginResponse.user?.addreses == nil {
//                                let vc = RegisterAddCardVC.getVC(.main)
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            } else if loginResponse.user?.documents?.count == 0 {
//                                let vc = DrivingLicenceCameraVC.getVC(.main)
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            } else {
                                self.navigationController?.viewControllers.remove(at: 0)
                                let vc = HomeVC.getVC(.main)
                                vc.objLoginResponse = self.objLoginResponse
                                let navCtrl = UINavigationController(rootViewController: vc)
                                UIApplication.shared.keyWindow?.rootViewController = navCtrl
                            //}
                           
                            
//                        } else {
//                            let alert = UIAlertController(title: TitleType.alert.localized, message: AlertMessage.profilePendingReview.rawValue, preferredStyle: .alert)
//
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
                        
                        
                    } else {
                        var style = ToastManager.shared.style
                        style.messageAlignment = .center
                        self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom, style: style)
                        print(/loginResponse.message)
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                break
            case .failure(_):
                print("response.result.error ",response.result.error as Any)
                break
            }
            //
            
        })
    }
}
