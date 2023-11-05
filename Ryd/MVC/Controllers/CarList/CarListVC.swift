//
//  CarListVC.swift
//  Ryd
//
//  Created by Harsh on 26/05/21.
//

import UIKit
import SDWebImage

struct CarList {
    var carName: String?
    var carId: String?
    var carImg: UIImage?
    var carType: String?
}

protocol CarSelected: class {
    func selectCar(serviceId:Int)
}

class CarListVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    weak var delegate : CarSelected?
    var selectedRow = -1
    var carListArray : [FindServiceResponse]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl.delegate = self
        tbl.dataSource = self
        btnSelect.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self,selector: #selector(carlists(_:)),name: .carLists,object: nil)
        
    }
    
    @IBAction func btnSelectAction(_ sender: Any) {
        delegate?.selectCar(serviceId: 6)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnScheduleAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func carlists(_ notification: Notification){
       
        let arrayCarlist = notification.userInfo?["userInfo"] as? NSArray
       
        if /arrayCarlist?.count > 0 {
            for indexx in 0 ..< /arrayCarlist?.count {
                guard let dict = arrayCarlist?[indexx] as? FindServiceResponse else { return }
                self.carListArray?.append(dict)
            }
        
            self.tbl.reloadData()
        }
        
        
    }
    
}

extension CarListVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carListArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CarListTbCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CarListTbCell", for: indexPath) as? CarListTbCell
        //cell?.imgVw.image = carListArray[indexPath.row].carImg
        let imgUrl = carListArray?[indexPath.row].image
        
        cell?.imgVw.sd_setImage(with: URL(string: /imgUrl), placeholderImage: #imageLiteral(resourceName: "car_XS"))
        cell?.lblCarName.text =  carListArray?[indexPath.row].title
        if selectedRow == indexPath.row {
            cell?.vwChild.layer.borderColor = UIColor.appColor.cgColor
            cell?.vwChild.layer.borderWidth = 1
        }
        else {
            cell?.vwChild.layer.borderColor = UIColor.clear.cgColor
            cell?.vwChild.layer.borderWidth = 0
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        btnSelect.layer.borderColor = UIColor.appColor.cgColor
        btnSelect.setTitleColor(UIColor.appColor, for: .normal)
        btnSelect.isUserInteractionEnabled = true
        tbl.reloadData()
    }
}
