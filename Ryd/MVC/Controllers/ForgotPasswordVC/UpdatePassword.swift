//
//  UpdatePassword.swift
//  DriverApp
//
//  Created by Prepladder on 19/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class UpdatePassword: UIViewController {
    
    @IBOutlet weak var txtNewpassword: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var objApi = ApiManager()
    var objForgotPasswordVerify : ForgotPasswordVerify?
    var objRecoverPassword : RecoverPassword?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
        //txtNewpassword.becomeFirstResponder()
        txtNewpassword.delegate = self
        txtConfirmPassword.delegate = self
        
    }
    
    @IBAction func sendRequestAction(_ sender: Any) {
        if validation(){
            let newPasswordStr = txtNewpassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmPasswordStr = txtConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                callUpdatePasswordApi(newPassword: newPasswordStr, confirmPassword: confirmPasswordStr)
                
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
        }
        
        
    }
    
}
}
extension UpdatePassword : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 20
        
    }
}

extension UpdatePassword {
    func validation()-> Bool{
        let newPasswordStr = txtNewpassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPasswordStr = txtConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newPasswordStr == "" {
            txtNewpassword.showErrorWithText(errorText: AlertMessage.emptyNewPassword.localized)
            return false
        } else if newPasswordStr.count < 6 {
            txtNewpassword.showErrorWithText(errorText: AlertMessage.invalidPassword.localized)
            return false
        }else if confirmPasswordStr == "" {
            txtConfirmPassword.showErrorWithText(errorText: AlertMessage.emptyConfirmPassword.localized)
            return false
        }else if newPasswordStr != confirmPasswordStr {
            txtConfirmPassword.showErrorWithText(errorText: AlertMessage.passwordNotMatch.localized)
            return false
        }
        return true
    }
    
    func callUpdatePasswordApi(newPassword: String,confirmPassword:String){
                
        let params = [
            "new_password": newPassword,
            "confirm_password": confirmPassword,
            "token": /objForgotPasswordVerify?.token
        ] as [String : Any]
        
        print("UPdate Password PARAMS => ", params)
        
        
        self.objApi.recoverPassword(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(RecoverPassword.self, from: /response.data)
                    if loginResponse.status == true {
                        let alert = UIAlertController(title: "", message: loginResponse.message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            let vc = ViewController.getVC(.main)
                            self.navigationController?.setViewControllers([vc], animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
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
