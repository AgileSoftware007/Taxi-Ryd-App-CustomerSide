//
//  UpdatePhoneVC.swift
//  DriverApp
//
//  Created by Prepladder on 21/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SDWebImage

class UpdatePhoneVC: BaseVC {
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var objApiManager = ApiManager()
    var objLoginResponse : LoginResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBackButton(str: "")
       // txtPhoneNumber.becomeFirstResponder()
        txtPhoneNumber.delegate = self
        addTapGesture()
        let imgUrl = objApiManager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        setDate()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setDate() {
        self.txtPhoneNumber.text = self.objLoginResponse?.user?.phonenumber
      //  self.btnDate.setTitle(self.objLoginResponse?.user?.created, for: .normal)
//        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
//        btnDate.setTitle(dateArray?[0], for: .normal)
        
        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        let yearArray = dateArray?[0].components(separatedBy: "-")
        let yearStr = yearArray?[0]
        let concateStr = "Since " + /yearStr
        btnDate.setTitle(concateStr, for: .normal)
    }
    
    @IBAction func editPicBtnAction(_ sender: Any) {
        self.cellTappedMethod()
    }
    
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
       // self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
        if validation(){
            let phoneStr = txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
               callupdatePhoneNumberApi(phoneNumber: phoneStr)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
}

extension UpdatePhoneVC: UITextFieldDelegate {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let phoneStr = txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if phoneStr == "" {
            self.view.makeToast(AlertMessage.emptyPhoneNumber.localized, duration: 3.0, position: .bottom)
            //txtPhoneNumber.showErrorWithText(errorText: AlertMessage.emptyPhoneNumber.localized)
            return false
        } else if phoneStr.count < 10{
            self.view.makeToast(AlertMessage.invalidPhoneNumber.localized, duration: 3.0, position: .bottom)
            //txtPhoneNumber.showErrorWithText(errorText: AlertMessage.invalidPhoneNumber.localized)
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
    
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
    
}

extension UpdatePhoneVC {
    
    func callupdatePhoneNumberApi(phoneNumber: String){

        let params = [
            "country_code": CountryCode,
            "phonenumber": phoneNumber

        ] as [String : Any]

        print("Change Password PARAMS => ", params)


        self.objApiManager.updatePhoneNumber(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(RecoverPassword.self, from: /response.data)
                    if loginResponse.status == true {
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UDManager.set(encoded, forKey: UDKeys.LOGIN_INFO)
                            UDManager.synchronize()
                        }
                        let alert = UIAlertController(title: "", message: loginResponse.message, preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.navigationController?.popToRootViewController(animated: true)
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
