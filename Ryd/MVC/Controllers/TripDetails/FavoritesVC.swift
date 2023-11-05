//
//  FavoritesVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 23/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class FavoritesTBCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var vwContent: UIView!
}

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnAddFavorite: UIButton!
    @IBOutlet weak var vwNodataFound: UIView!
    var objApi = ApiManager()
    var objGetLocations : GetFavoriteListResponse?
    var isEditEnable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addFavoriteBackButton(str: "")
        
    }
    
    @IBAction func addFavoriteAction(_ sender: Any) {
        let vc = AddFavoritesVC.getVC(.tripDetails)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if Reachability.isConnectedToNetwork(){
           // showActivityIndicator(view: self.view, targetVC: self)
            callGetFavoritesLocations()
        }else {
            print(AlertMessage.noInternet.localized)
            self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
        }
    }
    
}

extension FavoritesVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.objGetLocations?.locations?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FavoritesTBCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTBCell", for: indexPath) as? FavoritesTBCell
        cell?.lblTitle.text = self.objGetLocations?.locations?[indexPath.row].location
//        if isEditEnable == true {
//            cell?.btnClear.isHidden = false
//        } else {
//            cell?.btnClear.isHidden = true
//        }
        cell?.btnClear.tag = indexPath.row
        cell?.btnClear.addTarget(self, action: #selector(deleteLocaton(sender:)), for: .touchUpInside)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func deleteLocaton(sender:UIButton){
        print(sender.tag)
        let alert = UIAlertController(title: "", message: AlertMessage.delete.localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            //showActivityIndicator(view: self.view, targetVC: self)
            let id = self.objGetLocations?.locations?[sender.tag].id
            self.callDeleteFavoritesLocations(address_id: /id)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in
            //self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addFavoriteBackButton(str: String) {
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
        if isEditEnable == false {
            isEditEnable = true
            self.tbl.reloadData()
        }else {
            isEditEnable = false
            self.tbl.reloadData()
        }
    }
    
}


extension FavoritesVC {
    
    func callGetFavoritesLocations(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        print("Get Favorites Locations PARAMS => ", params)
        
        
        self.objApi.getFavorites(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(GetFavoriteListResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        self.objGetLocations = loginResponse
                        if self.objGetLocations?.locations?.count == 0 {
                            self.vwNodataFound.isHidden = false
                        } else {
                            self.vwNodataFound.isHidden = true
                        }
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
    
    
    func callDeleteFavoritesLocations(address_id:Int){
        
        let params = [
            "id": address_id
        ] as [String : Any]
        
        print("Delet Location PARAMS => ", params)
        
        
        self.objApi.deleteFavorites(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(DeleteFavoriteLocation.self, from: /response.data)
                    if loginResponse.status == true {
                        let alert = UIAlertController(title: "", message: AlertMessage.deleteFavoriteLocation.localized, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.isEditEnable = false
                            self.callGetFavoritesLocations()
                            self.tbl.reloadData()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
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

