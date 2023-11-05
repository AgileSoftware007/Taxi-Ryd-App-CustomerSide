//
//  CarListTbCell.swift
//  Ryd
//
//  Created by Harsh on 26/05/21.
//

import UIKit

class CarListTbCell: UITableViewCell {

    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblNumberPerson: UILabel!
    @IBOutlet weak var lblAwayTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vwChild: UIView!
    @IBOutlet weak var txtSource: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
