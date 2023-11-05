//
//  ForgotPasswordOTP.swift
//  Ryd
//
//  Created by Harsh on 08/08/21.
//

import UIKit

class ForgotPasswordOTP: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDate: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var objApiManager = ApiManager()
    var objLoginResponse : LoginResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // addBackButton(str: "")
        
        self.navigationController?.navigationBar.isHidden = true
        self.initialsetup()
    }
    
    
    func initialsetup(){
    
        let imgUrl = objApiManager.BASE_URL + /self.objLoginResponse?.user?.image?.original
        imgVw.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))

        let dateArray = self.objLoginResponse?.user?.created?.components(separatedBy: " ")
        let yearArray = dateArray?[0].components(separatedBy: "-")
        let yearStr = yearArray?[0]
        let concateStr = "Since " + /yearStr
        lblDate.setTitle(concateStr, for: .normal)
        
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        let vc = UpdatePasswordVC.getVC(.home)
        vc.comesFrom = "ForgotPasswordOTP"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
