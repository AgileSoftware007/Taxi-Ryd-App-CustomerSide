//
//  RegisterAddCardVC.swift
//  DriverApp
//
//  Created by Harsh on 09/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import MBProgressHUD
import MonthYearPicker
import NTMonthYearPicker

class RegisterAddCardVC: UIViewController {
    
    @IBOutlet weak var txtCardName: ACFloatingTextfield!
    @IBOutlet weak var txtCardNumber: ACFloatingTextfield!
    @IBOutlet weak var txtBillingZip: ACFloatingTextfield!
    @IBOutlet weak var txtCvv: ACFloatingTextfield!
    @IBOutlet weak var txtExpiryDate: ACFloatingTextfield!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var datePicker: NTMonthYearPicker!
    
    var userProfile: User?
    var objApi = ApiManager()
    var stateArray = [State]()
    var objCardResponse : AddCardResponse?
    let picker = MonthYearPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addBackButton()
        makeborder(sender: btnSave)
        makeborder(sender: btnCancel)
        initialSetup()
    }
    
    
    @IBAction func doneDatePickerTap(_ sender: Any) {
        vwDatePicker.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        txtExpiryDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelDatePicker(_ sender: Any) {
        vwDatePicker.isHidden = true
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func initialSetup(){
        // txtMailingAddress.becomeFirstResponder()
        txtCardName.delegate = self
        txtCardNumber.delegate = self
        txtExpiryDate.delegate = self
        txtCvv.delegate = self
        txtBillingZip.delegate = self
        
        txtCardName.text = (/userProfile?.firstName + " " + /userProfile?.lastName).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBAction func SaveBtnAction(_ sender: Any) {
        
        if validation(){
            let name = txtCardName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let number = txtCardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let billing = txtBillingZip.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cvv = txtCvv.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let expiry = txtExpiryDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Reachability.isConnectedToNetwork(){
                //showActivityIndicator(view: self.view, targetVC: self)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                callBankCardApi(cardName: name, cardNumber: number, billingZip: billing, expiryDate: expiry, cvv: cvv)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
            
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        let vc = UserProfileVC.getVC(.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension RegisterAddCardVC {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let maillinStr = txtCardName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressStr = txtCardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityStr = txtBillingZip.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipCodeStr = txtCvv.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let stateStr = txtExpiryDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if maillinStr == "" {
            txtCardName.showErrorWithText(errorText: AlertMessage.emptyCardName.localized)
            return false
        }
        else if addressStr == ""{
            txtCardNumber.showErrorWithText(errorText: AlertMessage.emptyCardNumber.localized)
            return false
        }else if stateStr == ""{
            txtExpiryDate.showErrorWithText(errorText: AlertMessage.emptyCardDate.localized)
            return false
        } else if zipCodeStr == "" {
            txtCvv.showErrorWithText(errorText: AlertMessage.emptyCardCvv.localized)
            return false
        }else if cityStr == "" {
            txtBillingZip.showErrorWithText(errorText: AlertMessage.emptyZipCode.localized)
            return false
        }
        return true
    }
    
}

//MARK:- API CALL
extension RegisterAddCardVC {
    
    func callBankCardApi(cardName: String, cardNumber: String, billingZip: String, expiryDate: String, cvv: String){
        // let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "card_name": cardName,
            "card_number": cardNumber,
            "expiry_date": expiryDate,
            "billing_zip": billingZip,
            "cvv": cvv
        ] as [String : Any]
        
        print("CARD SAVE PARAMS => ", params)
        
        
        self.objApi.saveCardInfo(parameters: params, completion: { (response) in
            //hideActivityIndicator(view: self.view)
            MBProgressHUD.hide(for: self.view, animated: true)
            print("ADDRESS RESPONSE ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(AddCardResponse.self, from: /response.data)
                    print("loginResponse ",loginResponse)
                    if loginResponse.status == true {
                        // UDManager.set(true, forKey: UDKeys.IS_ADDRESS_COMEPLETE)
                        let vc = UserProfileVC.getVC(.main)
                        self.navigationController?.pushViewController(vc, animated: true)
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

extension RegisterAddCardVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        vwDatePicker.isHidden = true
        if textField == txtCardName
        {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet && range.location < 20
            
        }
        else if  textField == txtCardNumber  {
            return range.location < 16
        } else if textField == txtCvv {
            return range.location < 3
        }
        else if textField == txtBillingZip {
            return range.location < 5
        }
        else {
            return true
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField  != txtExpiryDate {
            vwDatePicker.isHidden = true
        }
    }
    
    
    func callGetStates(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        self.objApi.getStates(parameters: params, completion: { (response) in
            print("GET STATE RESPONSE ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(GetStatesResponse.self, from: /response.data)
                    self.stateArray = loginResponse.states ?? []
                    //                    self.setDropdownData()
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

extension RegisterAddCardVC {
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
    
    
    @IBAction func showDataPickerTap(_ sender: Any) {
        vwDatePicker.isHidden = false
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 50, to: Date())
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
