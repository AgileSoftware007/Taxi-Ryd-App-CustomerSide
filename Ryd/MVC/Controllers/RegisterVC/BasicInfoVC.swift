//
//  BasicInfoVC.swift
//  
//
//  Created by Harsh on 09/04/21.
//

import UIKit
import ACFloatingTextfield_Swift
import MBProgressHUD
import DropDown

class BasicInfoVC: UIViewController {
    
    @IBOutlet weak var txtName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmEmail: ACFloatingTextfield!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var selectGender: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    let genderDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.genderDropDown
        ]
    }()
    
    var objApi = ApiManager()
    var objOTPResponse : OTPAuthResponse? {
        didSet{
            setData()
        }
    }
    var gender = "Select"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.addBackButton()
        setDropdownData()
        self.makeborder(sender: btnSave)
        self.makeborder(sender: btnCancel)
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func initialSetup(){
       // txtName.becomeFirstResponder()
        txtEmail.delegate = self
        txtLastName.delegate = self
        txtConfirmEmail.delegate = self
     //   txtGender.delegate = self
        txtName.delegate = self
    }
    
    @IBAction func SaveBtnAction(_ sender: Any) {
        if validation() {
            
            let nameStr = txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastNameStr = txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            if Reachability.isConnectedToNetwork(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.callEditProfile(firstName: nameStr, lastName: lastNameStr, gender: gender, email: emailStr)
                
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
        }
        
    }
    
    @IBAction func selectGenderAction(_ sender: Any) {
        btnMale.isHidden = false
        btnFemale.isHidden = false
        btnSelect.isHidden = true
        self.selectGender.text = "Select"
    }
    
    @IBAction func maleBtnAction(_ sender: UIButton) {
        self.selectGender.text = "Male"
        btnMale.isHidden = true
        btnFemale.isHidden = true
        btnSelect.isHidden = false
        gender = /self.selectGender.text
    }
    
    @IBAction func feMaleBtnAction(_ sender: Any) {
        self.selectGender.text = "Female"
        btnMale.isHidden = true
        btnFemale.isHidden = true
        btnSelect.isHidden = false
        gender = /self.selectGender.text
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData(){
        self.txtName.text = self.objOTPResponse?.user?.firstName
        self.txtLastName.text = self.objOTPResponse?.user?.lastName
        self.txtEmail.text = self.objOTPResponse?.user?.email
        self.txtConfirmEmail.text = self.objOTPResponse?.user?.email
    }
    
    func validation()-> Bool{
        let nameStr = txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastNameStr = txtLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailStr = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmEmailStr = txtConfirmEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if gender == "Select" {
            self.view.makeToast(AlertMessage.emptyGender.localized, duration: 3.0, position: .bottom)
            return false
        }
        else if nameStr == "" {
             txtName.showErrorWithText(errorText: AlertMessage.emptyName.localized)
            return false
        } else if lastNameStr == ""{
             txtLastName.showErrorWithText(errorText: AlertMessage.emptyLastName.localized)
            return false
        } else if emailStr == "" {
             txtEmail.showErrorWithText(errorText: AlertMessage.emptyEmail.localized)
            return false
        } else if isValidEmail(email: emailStr) == false {
            txtEmail.showErrorWithText(errorText: AlertMessage.invalidEmail.localized)
            return false
        } else if confirmEmailStr == "" {
             txtConfirmEmail.showErrorWithText(errorText: AlertMessage.emptyConfirmEmail.localized)
            return false
        } else if emailStr != confirmEmailStr {
            txtConfirmEmail.showErrorWithText(errorText: AlertMessage.confirmEmailNotMatch.localized)
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
//MARK:- API CALL
extension BasicInfoVC {
    
    func callEditProfile(firstName: String, lastName: String, gender: String, email: String){
       // let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender,
            "email": email
        ] as [String : Any]
        
        print("EDIT PROFILE PARAMS => ", params)
        
        
        self.objApi.editProfile(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("EDIT PROFILE RESPONSE ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(UpdateProfileResponse.self, from: /response.data)
                    print("PROFILE RESPONSE ",loginResponse)
                    if loginResponse.status == true {
                        let vc = RegisterAddCardVC.getVC(.main)
                        vc.userProfile = loginResponse.user
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
    func setDropdownData(){
        //        self.txtGender.shadowColor = UIColor.clear
        //        self.txtGender.checkMarkEnabled = false
        //
        //        self.txtGender.rowBackgroundColor = UIColor.white
        //        self.txtGender.arrowColor = UIColor.clear
        //        self.txtGender.optionArray = ["Female","Male"]
        //       // self.txtGender.optionIds = nil
        //        self.txtGender.didSelect{ [weak self](selectedText, id, index)  in
        //           self?.gender = selectedText
        //            print(selectedText)
        //        }
        //        self.txtGender.alignmentRect(forFrame: CGRect(x: 15, y: 0, width: 0, height: 0)
        //                                        )
        
        
        genderDropDown.anchorView = btnMale
        
        genderDropDown.bottomOffset = CGPoint(x: 0, y: btnMale.bounds.height + 10)
        
        genderDropDown.dataSource = ["       Female","        Male"]
        
        genderDropDown.anchorView?.plainView.tintAdjustmentMode = .automatic
        
        
        genderDropDown.selectionAction = { [weak self] (index, item) in
            print("item ",item)
            let trimmedString = item.trimmingCharacters(in: .whitespacesAndNewlines)
            print("trimmedString ",trimmedString)
            self?.txtGender.text = trimmedString
            self?.gender = item
        }
        
    }
}

extension BasicInfoVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtGender {
            return false
        }
        if textField == txtName || textField == txtLastName  {
            return range.location < 20
        }else {
            return true
        }
        
    }
   
    
}

extension BasicInfoVC {
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
    
    @IBAction func selectGender(_ sender: Any) {
        genderDropDown.show()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
