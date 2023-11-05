//
//  FinishTripVC.swift
//  Ryd
//
//  Created by Harsh on 09/08/21.
//

import UIKit
import Cosmos
import MBProgressHUD


protocol FinishTrip : class {
    func paymentSuccess()
}

class ColVwCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwBorder: UIView!
    
}

class FinishTripVC: UIViewController {

    weak var delegate: FinishTrip?
    @IBOutlet weak var vwRating: CosmosView!
    
    @IBOutlet weak var lblRatingTitle: UILabel!
    
    @IBOutlet weak var imgVwDriver: UIImageView!
    
    @IBOutlet weak var vwAddOtherPayment: UIView!
    @IBOutlet weak var btnOtherPayment: UIButton!
    
    @IBOutlet weak var txtOtherPayment: UITextField!
    
    @IBOutlet weak var btnTipOne: UIButton!
    @IBOutlet weak var btnTipTwo: UIButton!
    @IBOutlet weak var btnTipFive: UIButton!
    
    @IBOutlet weak var vWTipOne: UIView!
    @IBOutlet weak var vWTipTwo: UIView!
    @IBOutlet weak var vWTipFive: UIView!
    
    var objDriver : Driver?
    
    var dict = NSDictionary()
    
    var ratingStr = "5"
    var tipStr = "0"
    
    @IBOutlet weak var colVw: UICollectionView!
    
    var objApi = ApiManager()
    
    var countArray = [1,2,3,4,5,6,7,8,9,11,0,12]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRatingView()
     
        print("dict dic t",dict)
        
        let imgUrll = self.objApi.BASE_URL + /self.objDriver?.driverImage?.medium
        imgVwDriver.sd_setImage(with: URL(string: imgUrll), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        
        imgVwDriver.layer.cornerRadius = imgVwDriver.frame.size.height / 2
        imgVwDriver.layer.masksToBounds = true
        
    }
    
    
    func setupRatingView(){
        
        vwRating.settings.filledColor = UIColor.ratingStarColor
        vwRating.settings.emptyBorderColor = UIColor.ratingStarColor
        vwRating.settings.fillMode = .full
        vwRating.settings.starSize = 30
        vwRating.settings.starMargin = 10
        vwRating.didFinishTouchingCosmos = {  rating in
            self.ratingStr = "\(rating)"
            print("ratinggg",String(rating))
            switch rating {
            case 1.0:
                self.lblRatingTitle.text = "Bad"
            case 2.0:
                self.lblRatingTitle.text = "It could be better"
            case 3.0:
                self.lblRatingTitle.text = "Ok"
            case 4.0:
                self.lblRatingTitle.text = "Good"
            case 5.0:
                self.lblRatingTitle.text = "Excellent!"
            default:
                print("default")
            }

        }
        
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let tripId = dict.value(forKey: "trip_id")
            print("tripId iddd ",tripId ?? 0)
            self.callPaymentChargeApi(tripId: "\(tripId ?? 0)", tip: tipStr, rating: "5")
        }else {
            print(AlertMessage.noInternet.localized)
            self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
        }
        
       
        
    }

    
    @IBAction func addTipOne(_ sender: Any) {
        
        vWTipTwo.isHidden = true
        vWTipFive.isHidden = true
        btnTipOne.backgroundColor = UIColor.appColor
        btnTipOne.setTitleColor(UIColor.white, for: .normal)
      
        tipStr = "1.00"
    }
    
    
    
    @IBAction func addTipTwo(_ sender: Any) {
        
        
        vWTipOne.isHidden = true
        vWTipFive.isHidden = true
        btnTipTwo.backgroundColor = UIColor.appColor
        btnTipTwo.setTitleColor(UIColor.white, for: .normal)
      
        tipStr = "2.50"
    }
    
    
    @IBAction func addTipFive(_ sender: Any) {

        vWTipOne.isHidden = true
        vWTipTwo.isHidden = true
        
        btnTipFive.backgroundColor = UIColor.appColor
        btnTipFive.setTitleColor(UIColor.white, for: .normal)
      
        tipStr = "5.00"
    }
    
    
    @IBAction func crossBtnAction(_ sender: Any) {
        self.delegate?.paymentSuccess()
        self.dismiss(animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    @IBAction func addAnotherAmountBtnAction(_ sender: Any) {
        
        vwAddOtherPayment.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 618)

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [self] in
            self.vwAddOtherPayment.frame = CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height)
        }) { finished in

            }
        self.view?.addSubview(self.vwAddOtherPayment)
        
        
    }
    
    
    @IBAction func saveOtherPayment(_ sender: Any) {
        vwAddOtherPayment.removeFromSuperview()
        let str = txtOtherPayment.text!
        btnOtherPayment.setTitle(str, for: .normal)
    }
    
    
    func callPaymentChargeApi(tripId: String,tip: String,rating:String){
        
        let params = [
            
            "trip_id": tripId,
            "tip": tip,
            "rating": rating
            
        ] as [String : Any]
        
        print("PAYMENT CHARGE PARAMS => ", params)
        
        
        self.objApi.paymentCharge(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(UpdatePasswordResponse.self, from: /response.data)
                    if loginResponse.status == true {
                        let alert = UIAlertController(title: "", message: "Thanks fot the Trip!", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.delegate?.paymentSuccess()
                            self.dismiss(animated: true, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
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

extension FinishTripVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ColVwCell?
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColVwCell", for: indexPath) as? ColVwCell
        
       
            
            cell?.lblTitle.text = "\(countArray[indexPath.row])"
            
            cell?.vwBorder.borderWidthVw = 1
            
            cell?.vwBorder.layer.borderColor = UIColor.appColor.cgColor
            
            cell?.vwBorder.layer.masksToBounds = true
            
            cell?.vwBorder.layer.cornerRadius = 10
            
            cell?.vwBorder.layer.cornerRadius = 10
            

        if indexPath.row == 9 || indexPath.row == 11 {
            cell?.lblTitle.text = ""
            cell?.vwBorder.borderWidthVw = 0
        }
        return cell ?? UICollectionViewCell()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 9 || indexPath.row == 11 {
            
        }
        else {
            let amount = "\(countArray[indexPath.row])"
            print("amount ",amount)
            self.txtOtherPayment.text = "$ " + amount
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
