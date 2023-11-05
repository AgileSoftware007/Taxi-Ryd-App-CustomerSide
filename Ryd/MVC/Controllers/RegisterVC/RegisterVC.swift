//
//  RegisterVC.swift
//  DriverApp
//
//  Created by Harsh on 08/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import Alamofire
import Toast_Swift
import MBProgressHUD

class RegisterVC: UIViewController {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var txtPhoneNo: ACFloatingTextfield!
    @IBOutlet weak var txtPass: ACFloatingTextfield!
    @IBOutlet weak var txtConPass: ACFloatingTextfield!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var tcPrivlbl: UILabel!
    var btnChecked = false
    var objApi = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        //txtPhoneNo.becomeFirstResponder()
    }
    
    func initialSetup(){
       // self.addBackButton()
        makeborder(sender: btnSave)
        makeborder(sender: btnCancel)
        setUpPrivacyLabel()
        txtPhoneNo.delegate = self
         saveBtnDisable()
    }
    
    @IBAction func SaveBtnAction(_ sender: Any) {
        if validation(){
            let phoneStr = txtPhoneNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordStr = txtPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Reachability.isConnectedToNetwork(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.callSignUPApi(phoneNumberStr: phoneStr, passwordStr: passwordStr)
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
            
            
        }
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkedBtnAction(_ sender: Any) {
        if !self.btnChecked {
            self.btnCheckBox.setImage(UIImage(named: Asset.checkWhite.rawValue), for: .normal)
             self.saveBtnEnable()
            self.btnChecked = true
        }else {
            self.btnCheckBox.setImage(UIImage(named: Asset.IcUncheckWhite.rawValue), for: .normal)
              self.saveBtnDisable()
            self.btnChecked = false
            
        }
    }
    
    func saveBtnDisable(){
        //self.btnSave.backgroundColor = UIColor.buttonDisableColor
        self.btnSave.layer.borderColor = UIColor.buttonDisableColor.cgColor
        self.btnSave.setTitleColor(UIColor.buttonDisableColor, for: .normal)
        self.btnSave.isUserInteractionEnabled = false
    }
    
    func saveBtnEnable(){
        //self.btnSave.backgroundColor = UIColor.appColor
        self.btnSave.layer.borderColor = UIColor.white.cgColor
        self.btnSave.setTitleColor(UIColor.white, for: .normal)
        self.btnSave.isUserInteractionEnabled = true
    }
    
}


extension RegisterVC: UITextFieldDelegate {
    
    //MARK Check Validation of Text fields
    func validation()-> Bool{
        let phoneStr = txtPhoneNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordStr = txtPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPasswordStr = txtConPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if phoneStr == "" {
            txtPhoneNo.showErrorWithText(errorText: AlertMessage.emptyPhoneNumber.localized)
            return false
        } else if phoneStr.count < 10{
            txtPhoneNo.showErrorWithText(errorText: AlertMessage.invalidPhoneNumber.localized)
            return false
        } else if passwordStr == ""{
            txtPass.showErrorWithText(errorText: AlertMessage.emptyPassword.localized)
            return false
        }else if passwordStr.count < 6 {
            txtPass.showErrorWithText(errorText: AlertMessage.invalidPassword.localized)
            return false
        }else if confirmPasswordStr == "" {
            txtConPass.showErrorWithText(errorText: AlertMessage.emptyConfirmPassword.localized)
            return false
        }else if passwordStr != confirmPasswordStr {
            txtPass.showErrorWithText(errorText: AlertMessage.passwordNotMatch.localized)
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhoneNo {
            return range.location < 10
        } else if textField == txtPass {
            return range.location < 20
        }
        return true
        
    }
    
    
}


extension RegisterVC {
    
    
    func setUpPrivacyLabel(){
        
        // tcPrivacyLbl.text = "By clicking on Continue, you agree to our T&C and Privacy Policy"
        let mainstring: NSMutableAttributedString = NSMutableAttributedString(string: "By checking this I agree to Ryd’s Terms of Service & Privacy Policy")
        mainstring.setColorForText(textToFind: "Terms of Service", withColor: UIColor.white)
        mainstring.setColorForText(textToFind: "Privacy Policy", withColor: UIColor.white)
        tcPrivlbl.attributedText = mainstring
        
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tcPrivlbl.isUserInteractionEnabled = true
        tcPrivlbl.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = tcPrivlbl.text else { return }
        let termsRange = (text as NSString).range(of: "Terms of Service")
        // comment for now
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: tcPrivlbl, inRange: termsRange) {
            print("Tapped terms")
            // let tcurl = "https://www.oneprep.com/privacypolicy"
            let objWeb = WebVC()
            self.navigationController?.pushViewController(objWeb, animated: true)
            
        } else if gesture.didTapAttributedTextInLabel(label: tcPrivlbl, inRange: privacyRange) {
            print("Tapped privacy")
            let objWeb = WebVC()
            self.navigationController?.pushViewController(objWeb, animated: true)
            
            
        } else {
            print("Tapped none")
        }
    }
}

extension NSMutableAttributedString {
    func setColorForText(textToFind: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range != nil {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
    
    func setUnderlineForText(textToFind: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range != nil {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            self.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
    }
    
    
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
        mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))
        
        // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableStr)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}


extension RegisterVC {
    
    func callSignUPApi(phoneNumberStr: String, passwordStr: String){
        
        let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            Parameter.firstName.rawValue : "",
            Parameter.lastName.rawValue: "",
            Parameter.countryCode.rawValue: CountryCode,
            Parameter.phoneNumber.rawValue: phoneNumberStr,
            Parameter.password.rawValue: passwordStr,
            Parameter.deviceId.rawValue: /DEVICE_ID,
            Parameter.deviceType.rawValue : DEVICE_TYPE,
            Parameter.deviceName.rawValue : DEVICE_NAME,
            Parameter.fcmToken.rawValue: /token,
            Parameter.userType.rawValue: USER_TYPE
        ] as [String : Any]
        
        print("SIGNUP PARAMS => ", params)
        
        
        
        self.objApi.signUpAPI(parameters: params, completion: { (response) in
            //hideActivityIndicator(view: self.view)
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(SignUpResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        BARRERTOKEN = loginResponse.token ?? ""
                        
                        let vc = VerificationCodeVC.getVC(.main)
                        vc.comesFrom = SIGNUP
                        vc.signUpResponse = loginResponse
                        self.navigationController?.pushViewController(vc, animated: true)
                        
//                        let alert = UIAlertController(title: "Your verification code is", message: loginResponse.otp, preferredStyle: .alert)
//
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
//                            let vc = VerificationCodeVC.getVC(.main)
//                            vc.comesFrom = SIGNUP
//                            vc.signUpResponse = loginResponse
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }))
//                        self.present(alert, animated: true, completion: nil)
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

extension RegisterVC {
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
}

enum Parameter: String {
    case firstName = "first_name"
    case lastName = "last_name"
    case countryCode = "country_code"
    case phoneNumber = "phonenumber"
    case password = "password"
    case deviceId = "device_id"
    case deviceType = "device_type"
    case deviceName = "device_name"
    case fcmToken = "fcm_token"
    case userType = "user_type"
}
