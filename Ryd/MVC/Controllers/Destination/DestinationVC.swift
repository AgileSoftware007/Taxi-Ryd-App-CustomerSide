//
//  DestinationVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 25/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class DestinationTbCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwContent: UIView!
}

class DestinationVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var txtDestination: UITextField!
    var arrayDestination = ["1. 554 Main St. Alto, GA","2. 1241 Caller Rd. Roswell, GA","3. 973 Paper Rd. Marietta, GA"]
    var objApi = ApiManager()
    var objGetLocations : GetFavoriteListResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDestinationBackButton(str: "")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActivityIndicator(view: self.view, targetVC: self)
        callGetFavoritesLocations()
    }
}

extension DestinationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /objGetLocations?.locations?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DestinationTbCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "DestinationTbCell", for: indexPath) as? DestinationTbCell
        cell?.lblTitle.text = objGetLocations?.locations?[indexPath.row].location
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtDestination.text = objGetLocations?.locations?[indexPath.row].location
    }
    
    func addDestinationBackButton(str: String) {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  Asset.NdBackBtn.rawValue), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.appColor
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("   " + str, for: .normal)
        backButton.tintColor = UIColor.appColor
        backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backbtnAction(_:)), for: .touchUpInside)
        
        
        let rightButton = UIButton(type: .roundedRect)
        rightButton.setImage(UIImage(named:  Asset.IcSetting.rawValue), for: .normal) // Image can be downloaded from here below link
        rightButton.imageView?.tintColor = UIColor.appColor
        rightButton.titleLabel?.lineBreakMode = .byTruncatingTail
        rightButton.setTitle("   " + str, for: .normal)
        rightButton.tintColor = UIColor.appColor
        rightButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        rightButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        rightButton.addTarget(self, action: #selector(self.rightBackAction(_:)), for: .touchUpInside)
        
        
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.appWhiteColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.appWhiteColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.appWhiteColor
    }
    
    @objc func backbtnAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    
    @objc func rightBackAction(_ sender: UIButton) {
           print("Right Btn Tap")
       }
}

extension DestinationVC {
    
    func callGetFavoritesLocations(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        print("Get Favorites Locations PARAMS => ", params)
        
        
        self.objApi.getFavorites(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(GetFavoriteListResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        self.objGetLocations = loginResponse
//                        if self.objGetLocations?.locations?.count == 0 {
//                            self.vwNodataFound.isHidden = false
//                        } else {
//                            self.vwNodataFound.isHidden = true
//                        }
                        self.tbl.reloadData()
                    }else {
                        //   self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom)
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
