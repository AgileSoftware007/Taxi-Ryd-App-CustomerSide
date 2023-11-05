//
//  VehicleDocumentsVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 07/05/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class VehicleDocumentTBCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var imgVw: UIImageView!
}

class VehicleDocumentsVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    var headerArray = ["Documents","Vehicle Documents"]
    var cellArray = ["Driver's License","Profile Photo","Background Check"]
    var cellArray2 = ["Vehicle Registration","Vehicle Insurace"]
    var objLoginResponse : LoginResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
       // print(objLoginResponse?.user?.documents)
    }
    
}
extension VehicleDocumentsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return cellArray.count
//        } else {
//            return cellArray2.count
//        }
        
        return /objLoginResponse?.user?.documents?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VehicleDocumentTBCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDocumentTBCell", for: indexPath) as? VehicleDocumentTBCell
        
        cell?.lblTitle.text = objLoginResponse?.user?.documents?[indexPath.row].title
        
        if objLoginResponse?.user?.documents?[indexPath.row].verified == 1 {
            cell?.imgVw.image = UIImage(named: Asset.IcCheckBlue.rawValue)
        } else {
            cell?.imgVw.image = UIImage(named: Asset.IcSkip.rawValue)
        }

     
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView : VehicleDocumentTBCell?
        headerView = tbl.dequeueReusableCell(withIdentifier: "VehicleDocumentHeaderCell") as? VehicleDocumentTBCell
        headerView?.lblHeaderTitle.text = "Documents"
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UpdateVehicleDocumentVC.getVC(.home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   }
