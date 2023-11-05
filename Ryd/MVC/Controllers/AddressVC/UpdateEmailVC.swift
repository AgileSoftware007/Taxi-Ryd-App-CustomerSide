//
//  UpdateEmailVC.swift
//  DriverApp
//
//  Created by Prepladder on 21/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SDWebImage

class UpdateEmailVC: BaseVC {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnDate: UIButton! 
    @IBOutlet weak var imgVw: UIImageView!
    var objApiManager = ApiManager()
    var objLoginResponse : LoginResponse?
    override func viewDidLoad() {
        super.viewDidLoad()

      //  addBackButton(str: "")

        txtEmail.delegate = self
        addTapGesture()
        let imgUrl = objApiManager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        setDate()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
       // self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func editPicBtnAction(_ sender: Any) {
        self.cellTappedMethod()
    }
    
    func setDate() {
        self.txtEmail.text = objLoginResponse?.user?.email
        //self.btnDate.setTitle(self.objLoginResponse?.user?.created, for: .normal)
        //let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        //btnDate.setTitle(dateArray?[0], for: .normal)
        
        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        //self.lblDate.text = String(dateArray?[0] ?? "")
        let yearArray = dateArray?[0].components(separatedBy: "-")
        let yearStr = yearArray?[0]
        let concateStr = "Since " + /yearStr
        btnDate.setTitle(concateStr, for: .normal)
    }

    @IBAction func updateBtnAction(_ sender: Any) {
        if validation(){
            let emailStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                updateEmail(email: emailStr)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
        }
    }

}

extension UpdateEmailVC : UITextFieldDelegate {
    func validation()-> Bool{
        
        let emailStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if emailStr == "" {
            self.view.makeToast(AlertMessage.emptyPhoneNumber.localized, duration: 3.0, position: .bottom)
            return false
        }else if isValidEmail(email: emailStr) == false {
            self.view.makeToast(AlertMessage.invalidEmail.localized, duration: 3.0, position: .bottom)
            return false
        }
        return true
    }
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func updateEmail(email: String){
        
        let params = [
            "email": email
        ] as [String : Any]
        
        print("Change Email PARAMS => ", params)
        
        
        self.objApiManager.updateEmail(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(UpdateEmailResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UDManager.set(encoded, forKey: UDKeys.LOGIN_INFO)
                            UDManager.synchronize()
                        }
                        let alert = UIAlertController(title: "", message: loginResponse.message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            //self.navigationController?.popViewController(animated: true)
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

