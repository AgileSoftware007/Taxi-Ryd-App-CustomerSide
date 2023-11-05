//
//  PreferenceVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 23/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import MBProgressHUD

class CollectionVwCell : UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
}

class PreferenceVC: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var switchSpeakSpanish: UISwitch!
    @IBOutlet weak var switchContactEmail: UISwitch!
    @IBOutlet weak var switchFemaleDriver: UISwitch!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblGenderType: UILabel!
    var selectedIndex = [Int]()
    
    var objApi = ApiManager()
    var objLoginResponse : LoginResponse?
    var objLanguageResponse : GetLaguagesResponse? {
        didSet{
            self.colVw.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBackButton(str: "")
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.callGetLanguages()
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func makeborderr(sender: UIButton){
           sender.layer.cornerRadius = 12
           sender.layer.masksToBounds = true
           sender.layer.borderWidth = 2.0
           sender.layer.borderColor = UIColor.white.cgColor
       }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        var contactByeMail = 0
        var femaleDriver = 0
        var speakSpanish = 0
        if switchContactEmail.isOn {
            contactByeMail = 1
        }
        
        if switchFemaleDriver.isOn {
            femaleDriver = 1
        }
        
        if switchSpeakSpanish.isOn {
            speakSpanish = 1
        }
        if Reachability.isConnectedToNetwork(){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.savePrefrence(contactByEmail: contactByeMail, femaleDriverOnly: femaleDriver, spanishSpeaking: speakSpanish, languages: selectedIndex)
        }
        
    }
    
    func setData() {
        if self.objLoginResponse?.user?.gender == "female" {
            lblGenderType.text = "Only female drivers?"
        }else {
            lblGenderType.text = "Only male drivers?"
        }
        if self.objLoginResponse?.user?.femaleDriverOnly == "1" {
            self.switchFemaleDriver.isOn = true
        }else {
            self.switchFemaleDriver.isOn = false
        }
        if self.objLoginResponse?.user?.contactByEmail == "1" {
            self.switchContactEmail.isOn = true
        }else {
            self.switchContactEmail.isOn = false
        }
        if self.objLoginResponse?.user?.wheelChair == "1" {
            self.switchSpeakSpanish.isOn = true
        }else {
            self.switchSpeakSpanish.isOn = false
        }
        
//        let languageId = self.objLoginResponse?.user?.languages?.id
//        self.selectedIndex.append(/languageId)
        self.selectedIndex = self.objLoginResponse?.user?.languages?.compactMap({$0.id}) ?? []
        self.colVw.reloadData()
        
    }
    
}

extension PreferenceVC {
    
    //MARK:- Get Laguages Api call
    
    func callGetLanguages(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        self.objApi.getLanguages(parameters: params, completion: { (response) in
            print("GET Languages RESPONSE ",response.result.value ?? "")
            MBProgressHUD.hide(for: self.view, animated: true)
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
    
    //MARK:- Save Prefrence Api call
    
    
    
    func savePrefrence(contactByEmail: Int, femaleDriverOnly: Int, spanishSpeaking: Int, languages: [Int]){
        
        
        let params = [
            "contact_by_email": contactByEmail,
            "female_driver_only": femaleDriverOnly,
            "wheel_chair": spanishSpeaking,
            "languages": languages,
        ] as [String : Any]
        
        print("SAVE PREFRENCE PARAMS => ", params)
        
        
        self.objApi.savePreffrence(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("SAVE PREFRENCE RESPONSE ",response.result.value ?? "")
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

extension PreferenceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return /objLanguageResponse?.languages?.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : CollectionVwCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionVwCell", for: indexPath) as? CollectionVwCell
        cell?.lblTitle.text = objLanguageResponse?.languages?[indexPath.row].title
        let imgId = objLanguageResponse?.languages?[indexPath.row].id
        if selectedIndex.contains(obj: imgId) {
            cell?.imgVw.image = #imageLiteral(resourceName: "Ic_check")
        } else {
            cell?.imgVw.image = #imageLiteral(resourceName: "Ic_uncheck")
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgId = /objLanguageResponse?.languages?[indexPath.row].id
//        self.selectedIndex.removeAll()
        if let index = self.selectedIndex.firstIndex(where: {$0 == imgId}) {
            self.selectedIndex.remove(at: index)
        } else {
            self.selectedIndex.append(/objLanguageResponse?.languages?[indexPath.row].id)
        }
        self.colVw.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3.3, height: 45)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

