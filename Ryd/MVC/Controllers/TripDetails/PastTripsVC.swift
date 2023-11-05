//
//  PastTripsVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 23/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import MBProgressHUD

class PastTripsTbCell : UITableViewCell {
    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var lblDatetime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vwContent: UIView!
    
}

class PastTripsVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var vwNoDatafound: UIView!
    var objApi = ApiManager()

    var objPastTripResponse : PastTripResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBackButton(str: "")
        
        if Reachability.isConnectedToNetwork(){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            callPastTripAPI()
        }else {
            print(AlertMessage.noInternet.localized)
            self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
}
extension PastTripsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPastTripResponse?.trips?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PastTripsTbCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "PastTripsTbCell", for: indexPath) as? PastTripsTbCell
        
        cell?.lblSrNo.text = "\(indexPath.row + 1)"
        
        cell?.lblDatetime.text = objPastTripResponse?.trips?[indexPath.row].created
        
        let amount = /objPastTripResponse?.trips?[indexPath.row].customerTotal
        
        cell?.lblPrice.text = "$ " + amount
        
        if indexPath.row % 2 == 0 {
            cell?.vwContent.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        } else {
            cell?.vwContent.backgroundColor = UIColor.white
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TripDetailsVC.getVC(.tripDetails)
        vc.objPastTripResponse = objPastTripResponse?.trips?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PastTripsVC {
    
    func callPastTripAPI(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        print("PAST TRIPS PARAMS => ", params)
        
        
        self.objApi.getCustomerPastTrips(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(PastTripResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        self.objPastTripResponse = loginResponse
                        if /self.objPastTripResponse?.trips?.count == 0 {
                            self.vwNoDatafound.isHidden = false
                        }else{
                            self.vwNoDatafound.isHidden = true
                        }
                        self.tbl.reloadData()
                    }else {
                        
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
