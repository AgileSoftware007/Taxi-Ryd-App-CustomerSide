//
//  HelpIssueVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 24/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import MBProgressHUD

class HelpIssueVC: UIViewController {
    
    @IBOutlet weak var lblIssueDesc: UILabel!
    @IBOutlet weak var lblIssueName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
//    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtVw: UITextView!
    var issueName = ""
    var objApi = ApiManager()
    var objHelpCat : Category?
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
        self.lblIssueName.text = self.objHelpCat?.title
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
//        let nameStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        if nameStr == "" {
//            self.view.makeToast(AlertMessage.emptyEmail.localized, duration: 3.0, position: .bottom)
//        } else if isValidEmail(email: nameStr) == false {
//            self.view.makeToast(AlertMessage.invalidEmail.localized, duration: 3.0, position: .bottom)
//        } else {
//            let vc = HelpThanksVC.getVC(.help)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if validation() {
            let emailStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            var msgStr = txtVw.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            if msgStr == "Can you explain the issue?" {
                msgStr = ""
            }
            if Reachability.isConnectedToNetwork(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.saveHelpData(email: emailStr, msg: msgStr, id: /self.objHelpCat?.id)
            }
        }
    }
    
    
    func validation()-> Bool{
        
        let emailStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var msgStr = txtVw.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if msgStr == "Can you explain the issue?" {
            msgStr = ""
        }
        if emailStr == "" {
            self.view.makeToast(AlertMessage.emptyEmail.localized, duration: 3.0, position: .bottom)
            return false
        }else if isValidEmail(email: emailStr) == false {
            self.view.makeToast(AlertMessage.invalidEmail.localized, duration: 3.0, position: .bottom)
            return false
        } else if msgStr == "" {
            self.view.makeToast(AlertMessage.emptyHelpMessage.localized, duration: 3.0, position: .bottom)
            return false
        }
        return true
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
}

extension HelpIssueVC {
    //MARK:- Save Help Api call

    
    func saveHelpData(email: String, msg: String, id: Int ){
        
        
        let params = [
            "email": email,
            "message": msg,
            "help_category_id": id,
            
        ] as [String : Any]
        
        print("SAVE PREFRENCE PARAMS => ", params)
        
        
        self.objApi.saveHelp(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("SAVE HELP RESPONSE ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(SubmitHelpResponse.self, from: /response.data)
                    print("loginResponse ",loginResponse)
                    
                    if loginResponse.status == true {
                        let vc = HelpThanksVC.getVC(.help)
                        vc.msgStr = /loginResponse.message
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                    if loginResponse.status == true {
//                        UDManager.set(true, forKey: UDKeys.IS_ADDRESS_COMEPLETE)
//                        let vc = DrivingLicenceCameraVC.getVC(.main)
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }else {
//                        print(/loginResponse.message)
//                        self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom)
//                    }
                   
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
