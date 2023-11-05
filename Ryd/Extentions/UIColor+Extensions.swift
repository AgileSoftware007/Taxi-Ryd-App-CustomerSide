//
//  UIColor+Extensions.swift
//
//  Created by Apple on 23/08/18.
//  Copyright © 2018 Sandeep. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    class func colorDefaultDarkPink() -> UIColor {
        return UIColor.init(hexString: "DB0D7C")
    }
    

}

//Tab Bar Colors
extension UIColor
{
    static var appColor:UIColor {
        return #colorLiteral(red: 0.2588235294, green: 0.4980392157, blue: 0.7568627451, alpha: 1)
    }
    
    static var buttonDisableColor:UIColor {
              return #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
    
    static var ratingStarColor:UIColor {
              return #colorLiteral(red: 1, green: 0.7568627451, blue: 0.08235294118, alpha: 1)
    }

    static var appDarKGrayColor:UIColor {
           return #colorLiteral(red: 0.2156862745, green: 0.2117647059, blue: 0.3764705882, alpha: 0.5987532106)
       }
    static var applightGrayColor:UIColor {
        return #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
    }
    static var appWhiteColor:UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static var appNewDesignBackColorFBF9FE:UIColor {
        return #colorLiteral(red: 0.9843137255, green: 0.9764705882, blue: 0.9960784314, alpha: 1)
    }
    
    
    static var prepareHeaderBGF2E8FF:UIColor {
           return #colorLiteral(red: 0.9490196078, green: 0.9098039216, blue: 1, alpha: 1)
       }
    

    static var appNewDesignDarkBlue373660:UIColor {
        return #colorLiteral(red: 0.2156862745, green: 0.2117647059, blue: 0.3764705882, alpha: 1)
    }
    
    static var appLightWhiteColorF3F2F2:UIColor {
              return #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9725490196, alpha: 0.8393889127)
          }
    
    static var subjectTextColor:UIColor {
        return #colorLiteral(red: 0.05882352941, green: 0.8431372549, blue: 0.6862745098, alpha: 0.5389287243)
    }
    
    static var filterDisableBackgroundColor:UIColor {
              return #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 0.34)
          }
    
    static var appHeaderColorF1EFF0:UIColor {
        return #colorLiteral(red: 0.9450980392, green: 0.937254902, blue: 0.9411764706, alpha: 1)
    }
    
    static var appTextErrorColor:UIColor {
        return #colorLiteral(red: 1, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
    }
    
    
    static var tresF9F8F8:UIColor {
           return #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
       }
    
    /*==================New App BG=======================*/
    static var NewAppBGColor:UIColor {
        return #colorLiteral(red: 0.9843137255, green: 0.9764705882, blue: 0.9960784314, alpha: 1)
    }
    
    
    static var NewTextColor:UIColor {
        return #colorLiteral(red: 0.09803921569, green: 0.1098039216, blue: 0.1803921569, alpha: 1)
    }
    
    static var NewTextBG:UIColor {
        return #colorLiteral(red: 0.8823529412, green: 0.8705882353, blue: 0.8980392157, alpha: 1)
    }
    
    
    static var snackBarBGColor:UIColor {
        return #colorLiteral(red: 0.4980392157, green: 0.2078431373, blue: 0.9882352941, alpha: 1)
    }
    
    static var homeSectionTitleColor:UIColor {
        return #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
    }
    
    static var newheaderBackgroundColor:UIColor {
        return #colorLiteral(red: 0.9647058824, green: 0.9450980392, blue: 0.9960784314, alpha: 1)
    }
    
    static var cellBorderColor:UIColor {
           return #colorLiteral(red: 0.1764705882, green: 0.8705882353, blue: 0.7058823529, alpha: 1)
       }
    
    
    //MARK : BookMark Nav Color
    static var bookmarkNDNavColor:UIColor {
           return #colorLiteral(red: 0.9843137255, green: 0.9764705882, blue: 0.9960784314, alpha: 1)
       }
    static var headerbookmarColor:UIColor {
              return #colorLiteral(red: 0.9647058824, green: 0.9450980392, blue: 0.9960784314, alpha: 1)
          }
       
    static var headeingbookmarColor:UIColor {
           return #colorLiteral(red: 0.2156862745, green: 0.2117647059, blue: 0.3764705882, alpha: 1)
       }
    
    
    
   
    

    static  var colorDarkGrayPopUp:UIColor {
        return UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.75)
    }
////
    
    
    
}
