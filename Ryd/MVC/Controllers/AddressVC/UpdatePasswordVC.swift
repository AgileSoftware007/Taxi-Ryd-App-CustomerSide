//
//  UpdatePasswordVC.swift
//  DriverApp
//
//  Created by Prepladder on 21/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SDWebImage
import SVPinView

class UpdatePasswordVC: BaseVC {
    
    @IBOutlet weak var txtoldPassword: UITextField!
    @IBOutlet weak var txtnewPassword: UITextField!
    @IBOutlet weak var txtconfrmPassword: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var vwEnterCode: UIView!
    @IBOutlet weak var vwOldPassword: UIView!
    
    @IBOutlet weak var vwOTP: SVPinView!
    @IBOutlet weak var imgVw: UIImageView!

    var comesFrom = ""
    var objApiManager = ApiManager()
    var objLoginResponse : LoginResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBackButton(str: "")
        initialsetup()
        addTapGesture()
        otpViewSetUp()
        if self.comesFrom == "UserAccount" {
            vwEnterCode.isHidden = true
            vwOldPassword.isHidden = false
        } else {
            vwEnterCode.isHidden = false
            vwOldPassword.isHidden = true
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func otpViewSetUp(){
        
        vwOTP.textColor = UIColor.black
        
        vwOTP.style = .underline
        
        vwOTP.keyboardType = .phonePad
        vwOTP.activeBorderLineColor = UIColor.black
        vwOTP.borderLineColor = UIColor.black
        vwOTP.activeBorderLineThickness = 3
        vwOTP.borderLineThickness = 1.5
        vwOTP.shouldSecureText = false
        
        vwOTP.didFinishCallback = { [weak self] pin in
            print("didFinishCallback PIN ",pin)
                
            
        }
        
        vwOTP.didChangeCallback = { [weak self] pin in
            print("Change PIN ",pin)
        }
    }
    
    @IBAction func editPicBtnAction(_ sender: Any) {
        self.cellTappedMethod()
    }
    
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
       // self.imgVw.addGestureRecognizer(swipeRight)
    }
    func initialsetup(){
       
        txtoldPassword.delegate = self
        txtnewPassword.delegate = self
        txtconfrmPassword.delegate = self
        let imgUrl = objApiManager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        //let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        //btnDate.setTitle(dateArray?[0], for: .normal)
        
        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        //self.lblDate.text = String(dateArray?[0] ?? "")
        let yearArray = dateArray?[0].components(separatedBy: "-")
        let yearStr = yearArray?[0]
        let concateStr = "Since " + /yearStr
        btnDate.setTitle(concateStr, for: .normal)
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
        let oldPasswordStr = txtoldPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPasswordStr = txtnewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confrmPasswordStr = txtconfrmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validation() {
            callChangePasswordApi(oldPassword: oldPasswordStr, newPassword: newPasswordStr, confirmPassword: confrmPasswordStr)
        }
    }
    
    @IBAction func forgotPasswrdBtnAction(_ sender: Any) {
        let vc = ForgotPasswordOTP.getVC(.home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension UpdatePasswordVC: UITextFieldDelegate {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let addressStr1 = txtoldPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressStr2 = txtnewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityStr = txtconfrmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if addressStr1 == "" {
            self.view.makeToast(AlertMessage.emptyOldPassword.localized, duration: 3.0, position: .bottom)
            return false
        }else if addressStr2 == ""{
            self.view.makeToast(AlertMessage.emptyPassword.localized, duration: 3.0, position: .bottom)
            return false
        }else if addressStr2.count < 6{
            self.view.makeToast(AlertMessage.invalidPassword.localized, duration: 3.0, position: .bottom)
            return false
        }else if cityStr == ""{
            self.view.makeToast(AlertMessage.emptyConfirmPassword.localized, duration: 3.0, position: .bottom)
            return false
        }else if addressStr2 != cityStr {
            self.view.makeToast(AlertMessage.passwordNotMatch.localized, duration: 3.0, position: .bottom)
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        if textField == txtoldPassword || textField == txtnewPassword || textField == txtconfrmPassword {
        //
        //        }else {
        //            return true
        //        }
        return range.location < 20
    }
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
    
    
    
}
extension UpdatePasswordVC {
    func callChangePasswordApi(oldPassword: String,newPassword: String,confirmPassword:String){
        
        let params = [
            "old_password": oldPassword,
            "new_password": newPassword,
            "confirm_password": confirmPassword
            
        ] as [String : Any]
        
        print("Change Password PARAMS => ", params)
        
        
        self.objApiManager.changePassword(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(UpdatePasswordResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        let alert = UIAlertController(title: "", message: loginResponse.message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
