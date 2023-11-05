//
//  UserAccountVC.swift
//  DriverApp
//
//  Created by Prepladder on 21/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class CollctionVwCell : UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
}


class UserAccountVC: BaseVC {
    
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnMobileNo: UIButton!
    @IBOutlet weak var btnpassword: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnEditPic: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var objLoginResponse : LoginResponse?
    var objApiManager = ApiManager()
    var languageaArray = ["English"]
    var selectedIndex = [Int]()
    var objLanguageResponse : GetLaguagesResponse? {
        didSet{
            self.colVw.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // addBackButton(str: "")
        addTapGesture()
        setData()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.colVw.collectionViewLayout = layout
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
//        DispatchQueue.main.async {
//            self.callGetLanguages()
//
//        }
    }
    
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
        //  self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    func setData(){
        let name = /self.objLoginResponse?.user?.firstName?.capitalized + " " + /self.objLoginResponse?.user?.lastName?.capitalized
        btnName.setTitle(name, for: .normal)
        btnEmail.setTitle(self.objLoginResponse?.user?.email, for: .normal)
        let addressLine  = self.objLoginResponse?.user?.addreses?.addressLine
        let mailingAddress  = self.objLoginResponse?.user?.addreses?.mailingAddress
        let cityName  = self.objLoginResponse?.user?.addreses?.city
        let state  = self.objLoginResponse?.user?.addreses?.state
        let zipCode  = self.objLoginResponse?.user?.addreses?.zip
        let fullAddress =  /mailingAddress + " " + /addressLine + " , " + /cityName + " , " + /state + " " + /zipCode
        btnAddress.setTitle(fullAddress, for: .normal)
        
        let maskPhoneStr = self.format(with: "XXX-XXX-XXXX", phone: /self.objLoginResponse?.user?.phonenumber)
        print("maskPhoneStr ",maskPhoneStr)
        
        btnMobileNo.setTitle(maskPhoneStr, for: .normal)
        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        //self.lblDate.text = String(dateArray?[0] ?? "")
        let yearArray = dateArray?[0].components(separatedBy: "-")
        let yearStr = yearArray?[0]
        let concateStr = "Since " + /yearStr
        btnDate.setTitle(concateStr, for: .normal)
        
        let imgUrl = objApiManager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        
//        let languageId = self.objLoginResponse?.user?.languages?.id
        let languageId = self.objLoginResponse?.user?.languages?.first?.id
        self.selectedIndex.append(/languageId)
        self.colVw.reloadData()
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                // move numbers iterator to the next index
                index = numbers.index(after: index)
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

extension UserAccountVC {
    @IBAction func dateBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func nameBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func addressBtnAction(_ sender: Any) {
        let vc = UpdateAddressVC.getVC(.home)
        vc.objLoginResponse = self.objLoginResponse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mobileBtnAction(_ sender: Any) {
        let vc = UpdatePhoneVC.getVC(.home)
        vc.objLoginResponse = self.objLoginResponse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func passwordBtnAction(_ sender: Any) {
        let vc = UpdatePasswordVC.getVC(.home)
        vc.objLoginResponse = self.objLoginResponse
        vc.comesFrom = "UserAccount"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func emailBtnAction(_ sender: Any) {
        let vc = UpdateEmailVC.getVC(.home)
        vc.objLoginResponse = self.objLoginResponse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func applyBtnAction(_ sender: Any) {
    
        if Reachability.isConnectedToNetwork(){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.savePrefrence(contactByEmail: 0, femaleDriverOnly: 0, spanishSpeaking: 0, languages: selectedIndex)
        }
    
        
    }
    
    @IBAction func editPicBtnAction(_ sender: Any) {
        self.cellTappedMethod()
    }
}

extension UserAccountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return /objLanguageResponse?.languages?.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : CollctionVwCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollctionVwCell", for: indexPath) as? CollctionVwCell
        cell?.lblTitle.text = objLanguageResponse?.languages?[indexPath.row].title
        let imgId = objLanguageResponse?.languages?[indexPath.row].id
        if self.selectedIndex.contains(obj: imgId) {
            cell?.imgVw.image = #imageLiteral(resourceName: "Ic_check")
        } else {
            cell?.imgVw.image = #imageLiteral(resourceName: "Ic_uncheck")
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgId = /objLanguageResponse?.languages?[indexPath.row].id
        self.selectedIndex.removeAll()
        if let index = self.selectedIndex.firstIndex(where: {$0 == imgId}) {
            self.selectedIndex.remove(at: index)
        } else {
            self.selectedIndex.append(/objLanguageResponse?.languages?[indexPath.row].id)
        }
        self.colVw.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.5, height: 45)
    }
    
    
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return languageaArray.count
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        var cell : CollctionVwCell?
    //        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollctionVwCell", for: indexPath) as? CollctionVwCell
    //        cell?.lblTitle.text = languageaArray[indexPath.row]
    //        return cell ?? UICollectionViewCell()
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        self.selectedIndex = indexPath.row
    //        self.colVw.reloadData()
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: collectionView.frame.size.width / 2.2, height: 50)
    //    }
    
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
}

extension UserAccountVC {
    
    //MARK:- Get Laguages Api call
    
    func callGetLanguages(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        self.objApiManager.getLanguages(parameters: params, completion: { (response) in
            print("GET Languages RESPONSE ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(GetLaguagesResponse.self, from: /response.data)
                    self.objLanguageResponse = loginResponse
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
    
    func savePrefrence(contactByEmail: Int, femaleDriverOnly: Int, spanishSpeaking: Int, languages: [Int]){
        
        
        let params = [
            "languages": languages,
        ] as [String : Any]
        
        print("SAVE PREFRENCE PARAMS USERACCOUNT => ", params)
        
        
        self.objApiManager.savePreffrence(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("SAVE PREFRENCE RESPONSE USERACCOUNT ",response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom)
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UDManager.set(encoded, forKey: UDKeys.LOGIN_INFO)
                            UDManager.synchronize()
                        }
                        self.navigationController?.popToRootViewController(animated: true)
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

