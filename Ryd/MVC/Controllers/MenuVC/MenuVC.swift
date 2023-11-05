//
//  MenuVC.swift
//  DriverApp
//
//  Created by Harsh on 19/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SDWebImage

class TblCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
}

class MenuVC: BaseVC {
    
    var objOTPAuthResponse : OTPAuthResponse?
    var objLoginResponse : LoginResponse?
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    var titleArray = ["Account","Payments","Past Trips","Favorites","Preferences","Rating","Help","Log Out"]
    var objApimanager = ApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //menuBackButton()
        self.addTapGesture()
        
    }
    
    
    func addTapGesture(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pickImageFromPicker(_:)), name: .ImagePicker, object: nil)
        let swipeRight = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod))
        self.imgVw.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.objLoginResponse = self.getLoggedInUser()
        self.setData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func setData(){
        self.lblFirstName.text = self.objLoginResponse?.user?.firstName?.capitalized
        self.lblLastName.text = self.objLoginResponse?.user?.lastName?.capitalized
        let dateArray = self.objLoginResponse?.user?.created?.split(separator: " ")
        self.lblDate.text = String(dateArray?[0] ?? "")
        let imgUrl = objApimanager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
    }
    
    
    @objc fileprivate func pickImageFromPicker(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let imgName = userInfo["imgName"] as? UIImage {
                self.imgVw.image = imgName
            }
        }
    }
    
}

extension MenuVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TblCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "TblCell", for: indexPath) as? TblCell
        cell?.lblTitle.text = titleArray[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 {
            
//            let vc = FinishTripVC.getVC(.tripDetails)
//            vc.modalPresentationStyle = .fullScreen
//            self.navigationController?.present(vc, animated: true, completion: nil)

            let vc = UserAccountVC.getVC(.home)
            vc.objLoginResponse = self.objLoginResponse
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if indexPath.row == 1 {
            let vc = PaymentInfoVC.getVC(.payment)
            vc.objLoginResponse = self.objLoginResponse
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if indexPath.row == 2 {
            let vc = PastTripsVC.getVC(.tripDetails)
            // vc.objOTPResponse = self.objOTPAuthResponse
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            let vc = FavoritesVC.getVC(.tripDetails)
            // vc.objOTPResponse = self.objOTPAuthResponse
            self.navigationController?.pushViewController(vc, animated: true)

        }
//        else if indexPath.row == 4 {
//            let vc = VehicleDocumentsVC.getVC(.home)
//            vc.objLoginResponse = self.objLoginResponse
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        else if indexPath.row == 4 {
            let vc = PreferenceVC.getVC(.tripDetails)
            vc.objLoginResponse = self.objLoginResponse
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if indexPath.row == 5 {
            let vc = RatingVC.getVC(.tripDetails)
            // vc.objOTPResponse = self.objOTPAuthResponse
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if indexPath.row == 6 {
            let vc = HelpVC.getVC(.help)
           // vc.objOTPResponse = self.objOTPAuthResponse
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if indexPath.row == 7 {
            let alert = UIAlertController(title: "", message: AlertMessage.logout.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in

            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                

//                vc.modalPresentationStyle = .fullScreen
//                vc.modalTransitionStyle = .coverVertical
//                let navController = UINavigationController(rootViewController: vc)
//                navController.modalPresentationStyle = .overFullScreen
//                navController.navigationBar.barStyle = .default
//                self.navigationController?.present(navController, animated: true, completion: {
                    UDManager.removeObject(forKey: UDKeys.LOGIN_INFO)
                    UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                    UDManager.removeObject(forKey: UDKeys.BEARER_TOKEN)
                    SocketIOManager.sharedInstance.closeConnection()
                    UDManager.synchronize()
//                })
                let vc = ViewController.getVC(.main)
                self.navigationController?.setViewControllers([vc], animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MenuVC {
    func menuBackButton() {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  Asset.IcMenu.rawValue), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.clear
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("   ", for: .normal)
        backButton.tintColor = UIColor.white
        backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.dismissAction(_:)), for: .touchUpInside)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.appColor
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.appColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    @IBAction func menuBtnAction(_ sender: Any) {
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        self.navigationController?.view.layer.add(transition, forKey: nil)
//        // _ = self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.popViewController(animated: false)
    }
    @objc func dismissAction(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: nil)
        // _ = self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.popViewController(animated: false)
    }
}
