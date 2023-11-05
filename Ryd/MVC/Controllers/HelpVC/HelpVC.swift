//
//  HelpVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 24/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import MBProgressHUD

class HelpTbCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwContent: UIView!
}
class HelpVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    var objApi = ApiManager()
    var objHelpResponse : GetHelpCategoriesResponse? {
        didSet{
            self.tbl.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.callGetHelpCategories()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

extension HelpVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /objHelpResponse?.categories?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HelpTbCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "HelpTbCell", for: indexPath) as? HelpTbCell
        cell?.lblTitle.text = objHelpResponse?.categories?[indexPath.row].title
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HelpIssueVC.getVC(.help)
        vc.objHelpCat = objHelpResponse?.categories?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HelpVC {
    
    //MARK:- Get Help Categories Api call
    
    func callGetHelpCategories(){
        
        let params = [
            "":""
        ] as [String : Any]
        
        self.objApi.getHelpCategories(parameters: params, completion: { (response) in
            print("GET HELP RESPONSE ",response.result.value ?? "")
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(GetHelpCategoriesResponse.self, from: /response.data)
                   self.objHelpResponse = loginResponse
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
