//
//  UpdateAddressVC.swift
//  DriverApp
//
//  Created by Prepladder on 21/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SDWebImage

class UpdateAddressVC: BaseVC {
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnEditPic: UIButton!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    //@IBOutlet weak var txtState: DropDown!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var txtZipCode: UITextField!
    var objApiManager = ApiManager()
    var objLoginResponse: LoginResponse?
    var objApi = ApiManager()
    
    var stateArray = [State]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton(str: "")
        initialsetup()
        addTapGesture()
        setData()
    }
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
        self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.callGetStates()
        }
    }
    
    func initialsetup(){
       // txtAddress1.becomeFirstResponder()
        txtAddress1.delegate = self
        txtAddress2.delegate = self
        txtCity.delegate = self
        //txtState.delegate = self
        txtZipCode.delegate = self
    }
    
    func setData(){
        
        txtAddress1.text =  self.objLoginResponse?.user?.addreses?.mailingAddress
        txtAddress2.text =  self.objLoginResponse?.user?.addreses?.addressLine
        txtCity.text =  self.objLoginResponse?.user?.addreses?.city
       // txtState.text =  self.objLoginResponse?.user?.addreses?.state
        txtZipCode.text =  self.objLoginResponse?.user?.addreses?.zip
        //self.btnDate.setTitle(self.objLoginResponse?.user?.created, for: .normal)
        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        btnDate.setTitle(dateArray?[0], for: .normal)
        let imgUrl = objApiManager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
    }
}

extension UpdateAddressVC {
    
    @IBAction func updateBtnAction(_ sender: Any) {
        if validation() {
            let addressStr1 = txtAddress1.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let addressStr2 = txtAddress2.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cityStr = txtCity.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let stateStr = ""//txtState.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipCodeStr = txtZipCode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                callSaveAddress(mailingAddress: addressStr1, addressLine: addressStr2, city: cityStr, state: stateStr, zip: zipCodeStr)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
            
            
            
        }
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
    }
}

extension UpdateAddressVC: UITextFieldDelegate {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let addressStr1 = txtAddress1.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressStr2 = txtAddress2.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityStr = txtCity.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let stateStr = "" //txtState.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipCodeStr = txtZipCode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if addressStr1 == "" {
            self.view.makeToast(AlertMessage.emptyMaillingAddress.localized, duration: 3.0, position: .bottom)
            return false
        }else if cityStr == ""{
            self.view.makeToast(AlertMessage.emptyCity.localized, duration: 3.0, position: .bottom)
            return false
        }else if stateStr == ""{
            self.view.makeToast(AlertMessage.emptyState.localized, duration: 3.0, position: .bottom)
            return false
        }else if zipCodeStr == ""{
            self.view.makeToast(AlertMessage.emptyZipCode.localized, duration: 3.0, position: .bottom)
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAddress1 || textField == txtAddress2 || textField == txtCity {
            return range.location < 20
        }else if textField == txtZipCode {
            return range.location < 5
        }else if textField == txtZipCode {
            return range.location < 2
        }
        else {
            return range.location < 10
        }
        
    }
    
    
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
    
//    func setDropdownData(){
//        self.txtState.checkMarkEnabled = false
//        self.txtState.rowBackgroundColor = UIColor.white
//        self.txtState.arrowColor = UIColor.clear
//        //self.txtState.optionArray = ["AL","AK","AS","AZ","AR","CA","CO","CT","DE","DC","FL","GA","GU","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","MP","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VT","VA","VI","WA","WV","WI","WY"]
//
//        let stateName = self.stateArray.map({ (stateResponse) -> String in
//            return /stateResponse.stateCode
//        })
//
//        self.txtState.optionArray = stateName
//        self.txtState.optionIds = nil
//        self.txtState.didSelect{ [weak self](selectedText, id, index)  in
//            print(selectedText)
//        }
//    }
    
    
}

extension UpdateAddressVC {
    
    func callSaveAddress(mailingAddress: String, addressLine: String, city: String, state: String, zip: String){
        // let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "mailing_address": mailingAddress,
            "address_line": addressLine,
            "city": city,
            "state": state,
            "zip": zip
        ] as [String : Any]
        
        print("Address PARAMS => ", params)
        
        
        self.objApi.saveAddress(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print("ADDRESS RESPONSE ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(AddressResponse.self, from: /response.data)
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
                   // self.setDropdownData()
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

