//
//  AddDebitCardVC.swift
//  DriverApp
//
//  Created by Prepladder on 22/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import SDWebImage
import MBProgressHUD
import MonthYearPicker
import NTMonthYearPicker

class AddDebitCardVC: BaseVC {
    
    @IBOutlet weak var txtCardName: ACFloatingTextfield!
    @IBOutlet weak var txtCardNumber: ACFloatingTextfield!
    @IBOutlet weak var txtCVV: ACFloatingTextfield!
    @IBOutlet weak var txtZipCode: ACFloatingTextfield!
    //@IBOutlet weak var countryName: DropDown!
    @IBOutlet weak var txtMonth: ACFloatingTextfield!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var datePicker: NTMonthYearPicker!
    
    
    var objLoginResponse : LoginResponse?
    var objApimanager = ApiManager()
    var objApi = ApiManager()
    var objCardResponse : AddCardResponse?
    let picker = MonthYearPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
        addTapGesture()
        setData()
        txtCVV.delegate = self
        txtZipCode.delegate = self
        txtCardName.delegate = self
        txtCardNumber.delegate = self
        txtCardName.text = /self.objLoginResponse?.user?.firstName + " " + /self.objLoginResponse?.user?.lastName
        txtCardName.isUserInteractionEnabled = false
    }
    
    
   
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
        self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
        
        if validation(){
            let cardName = txtCardName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cardNoStr = txtCardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let monthStr = txtMonth.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cvvStr = txtCVV.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipCodeStr = txtZipCode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let countryNameStr = ""//self.countryName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Reachability.isConnectedToNetwork(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.callBankCardApi(cardName: cardName, cardNo: cardNoStr, month: monthStr, cvv: cvvStr, zip: zipCodeStr,countryName: countryNameStr)
                
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
            
        }
        
    }
    
    @objc func setData(){
        let imgUrl = objApimanager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
    }
    
}

extension AddDebitCardVC  {
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
}

extension AddDebitCardVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        vwDatePicker.isHidden = true
        if textField == txtCardNumber
        {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet && range.location < 16
            
        }
//        else if  textField == txtCardNumber  {
//            return range.location < 16
//        }
        else if textField == txtCVV {
            return range.location < 3
        }
        else if textField == txtZipCode {
            return range.location < 5
        }
        else {
            return true
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField  != txtMonth {
            vwDatePicker.isHidden = true
        }
        
        
        
    }
}

//MARK:- API CALL
extension AddDebitCardVC {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let cardNoStr = txtCardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let monthStr = txtMonth.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cvvStr = txtCVV.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipCodeStr = txtZipCode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let countryName = ""//self.countryName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
 
        if cardNoStr == "" {
            txtCardName.showErrorWithText(errorText: AlertMessage.emptyCardName.localized)
            return false
        }
        if cardNoStr == ""{
            txtCardNumber.showErrorWithText(errorText: AlertMessage.emptyCardNumber.localized)
            return false
        }else if monthStr == ""{
            txtMonth.showErrorWithText(errorText: AlertMessage.emptyCardDate.localized)
            return false
        }else if cvvStr == "" {
            txtCVV.showErrorWithText(errorText: AlertMessage.emptyCardCvv.localized)
            return false
        }
//        else if countryName == "" {
//            self.view.makeToast(AlertMessage.emptyCity.localized, duration: 3.0, position: .bottom)
//            return false
//        }
        else if zipCodeStr == "" {
            txtZipCode.showErrorWithText(errorText: AlertMessage.emptyZipCode.localized)
            return false
        }
        return true
    }
    
    func callBankCardApi(cardName: String, cardNo: String, month: String, cvv: String, zip: String, countryName:String){
        // let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "card_name": cardName,
            "card_number": cardNo,
            "expiry_date": month,
            "billing_zip": zip,
            "cvv": cvv
        ] as [String : Any]
        
        print("CARD SAVE PARAMS => ", params)
        
        
        self.objApi.saveCardInfo(parameters: params, completion: { (response) in
            //hideActivityIndicator(view: self.view)
            MBProgressHUD.hide(for: self.view, animated: true)
            print("CARD SAVE RESPONSE ",response.result )
            switch(response.result) {
            case .success(_):
                do {
                    let cardResponse = try JSONDecoder().decode(AddCardResponse.self, from: /response.data)
                    print("cardResponse ",cardResponse)
                    if cardResponse.status == true {
                        if let card = cardResponse.card {
                            if self.objLoginResponse?.user?.cards == nil {
                                self.objLoginResponse?.user?.cards = [card]
                            } else {
                                self.objLoginResponse?.user?.cards?.append(card)
                            }
                        }
                        if let loginModel = self.objLoginResponse, let encoded = try? JSONEncoder().encode(loginModel) {
                            UDManager.set(encoded, forKey: UDKeys.LOGIN_INFO)
                            UDManager.synchronize()
                        }

                        self.navigationController?.popViewController(animated: true)
                    }else {
                        print(/cardResponse.message)
                        self.view.makeToast(/cardResponse.message, duration: 3.0, position: .bottom)
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

extension AddDebitCardVC {
    
    @IBAction func doneDatePickerTap(_ sender: Any) {
        vwDatePicker.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        txtMonth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelDatePicker(_ sender: Any) {
        vwDatePicker.isHidden = true
        self.view.endEditing(true)
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
