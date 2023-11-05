//
//  RatingVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 23/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import Cosmos

class RatingVC: UIViewController {
    
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(str: "")
        
        setupRatingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setupRatingView(){
        
        vwRating.settings.filledColor = UIColor.ratingStarColor
        vwRating.settings.emptyBorderColor = UIColor.ratingStarColor
        vwRating.settings.fillMode = .full
        vwRating.settings.starSize = 30
        vwRating.settings.starMargin = 20
        vwRating.didFinishTouchingCosmos = {  rating in
            print("ratinggg",rating)
            self.lblRating.text = "\(rating)"
        }
        
        //   vwRating.didTouchCosmos = { rating in
        //   print("rating",rating)
        //   }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
