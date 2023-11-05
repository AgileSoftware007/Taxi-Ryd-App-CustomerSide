//
//  MessageTableCell.swift
//  Ryd
//
//  Created by Rakib Rz  on 08/11/22.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
    @IBOutlet weak var msgBgView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    func populate(message: String?, imageString: String?, time: String?) {
        messageLabel.text = message
        timeLabel.text = time
        if let image = imageString {
            userImageView.sd_setImage(with: URL(string: image))
        }
    }
    
    func setupBGView(senderisMe: Bool) {
        msgBgView.clipsToBounds = true
        msgBgView.layer.cornerRadius = 8
        
        let cornerMasks: CACornerMask = senderisMe ? [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner] : [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        msgBgView.layer.maskedCorners = cornerMasks
    }
}
