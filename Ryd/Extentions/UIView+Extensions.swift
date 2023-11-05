//
//  UIView+Extensions.swift
//
//  Created by Apple on 23/08/18.
//  Copyright © 2018 Sandeep. All rights reserved.
//

import UIKit

import NVActivityIndicatorView


extension UIView {
    class func loadNIB<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed(T.identifier, owner: nil, options: nil)?.last as? T else { fatalError() }
        return view
    }
    
    static func getNIB() -> Self {
        
        func loadNIB<T: UIView>() -> T {
            guard let view = Bundle.main.loadNibNamed(T.identifier, owner: self, options: nil)?.first as? T else {
                fatalError("Not View")
            }
            return view
        }
        return loadNIB()
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        //        animation.fillMode = CAMediaTimingFillMode.f
        self.layer.add(animation, forKey: nil)
    }
}

extension UITextField
{
    @IBInspectable var addBottomRArrow: Bool {
        get{
            return true
        }
        set {
            
            if addBottomRArrow {
                self.rightView = UIImageView(image: #imageLiteral(resourceName: "dropDown"))
                self.rightViewMode = .always
            }
        }
    }
}


extension UIView {
    
    //    func remodeGradient() {
    //        if let gradient = layer.sublayers?.first(where: { $0.accessibilityHint == "AddGradientBoarder" })
    //        {
    //            gradient.removeFromSuperlayer()
    //        }
    //
    //        if let gradient = layer.sublayers?.first(where: { $0.accessibilityHint == "addGradient" })
    //        {
    //            gradient.removeFromSuperlayer()
    //        }
    //    }
    
    //    func addGradientBoarder(cornerRadius: CGFloat? = 6.0, height: CGFloat? = 96.0) {
    //        let gradient = CAGradientLayer()
    //        gradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: /height)
    //        gradient.colors = [#colorLiteral(red:0.98, green:0.64, blue:0.11, alpha:1).cgColor, #colorLiteral(red:0.95, green:0.82, blue:0, alpha:1).cgColor]
    //        gradient.locations = [0, 1]
    //        gradient.startPoint = CGPoint(x: 1, y: 0)
    //        gradient.endPoint = CGPoint(x: 0, y: 1)
    //        gradient.cornerRadius = /cornerRadius
    //
    //        let shape = CAShapeLayer()
    //        shape.lineWidth = 2
    //        shape.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: /height)).cgPath
    //        shape.strokeColor = UIColor.black.cgColor
    //        shape.fillColor = UIColor.clear.cgColor
    //        shape.cornerRadius = /cornerRadius
    //        gradient.mask = shape
    //
    //        gradient.accessibilityHint = "AddGradientBoarder"
    //        layer.addSublayer(gradient)
    //
    //    }
    //
    //    func addGradient(cornerRadius: CGFloat? = 6.0, height: CGFloat? = 96.0) {
    //        let gradient = CAGradientLayer()
    //        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: /height)
    //        gradient.colors = [#colorLiteral(red:0.98, green:0.64, blue:0.11, alpha:1).cgColor, #colorLiteral(red:0.95, green:0.82, blue:0, alpha:1).cgColor]
    //        gradient.locations = [0, 1]
    //        gradient.startPoint = CGPoint(x: 1, y: 0)
    //        gradient.endPoint = CGPoint(x: 0, y: 1)
    //        gradient.cornerRadius = /cornerRadius
    //        gradient.accessibilityHint = "addGradient"
    //        self.layer.insertSublayer(gradient, at: 0)
    //    }
    //
    //    func addGradientWithColor(cornerRadius: CGFloat? = 6.0, height: CGFloat? = 96.0, colors: [UIColor] = []) {
    //        let gradient = CAGradientLayer()
    //        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: /height)
    //        gradient.locations = [0, 1]
    //        gradient.colors = colors.map({ $0.cgColor })
    //        gradient.startPoint = CGPoint(x: 1, y: 0)
    //        gradient.endPoint = CGPoint(x: 0, y: 1)
    //        gradient.cornerRadius = /cornerRadius
    //        gradient.accessibilityHint = "addGradient"
    //        self.layer.insertSublayer(gradient, at: 0)
    //    }
    //
    //    func updateGradient(colors: [UIColor]?) -> Bool {
    //
    //        if let gradient = getGradient() {
    //            gradient.frame = bounds
    //            gradient.colors = colors?.map({ $0.cgColor })
    //            return true
    //        }
    //        return false
    //    }
    
    
    
    //    func getGradient() -> CAGradientLayer? {
    //        return layer.sublayers?.first(where: { $0.accessibilityHint == "addGradient" }) as? CAGradientLayer
    //    }
}



//extension UIView
//{
////    @IBInspectable var bLine: Bool {
////        get {
////            return true
////        }
////        set {
////
////            if bLine {
////                ez.dispatchDelay(0.001) {
////                    [weak self] in
////                    guard let self = self else { return }
////
////                    let border = CALayer()
////                    border.borderColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.3).cgColor
////                    border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: self.frame.size.height)
////                    border.borderWidth = CGFloat(1.0)
////                    self.layer.addSublayer(border)
////                    self.layer.masksToBounds = true
////                }
////            }
////        }
////    }
//
//    @IBInspectable var bWidth:CGFloat {
//        get{
//            return layer.borderWidth
//        }
//        set{
//            layer.borderWidth = newValue
//            layer.masksToBounds = newValue > 0
//
//        }
//    }
//
//    @IBInspectable var bColor:UIColor{
//        get{
//            return UIColor.clear
//        }
//        set{
//            layer.borderColor = newValue.cgColor
//        }
//    }
//
//    @IBInspectable var cRadius:CGFloat{
//        get{
//            return layer.cornerRadius
//        }
//        set{
//            layer.cornerRadius = newValue
//        }
//    }
//
//
//    //Shadow
//    @IBInspectable var sOpacity:Float{
//        get{
//            return layer.shadowOpacity
//        }
//        set{
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    @IBInspectable var sOffSet:CGSize{
//        get{
//            return layer.shadowOffset
//        }
//        set{
//            layer.shadowOffset = newValue
//        }
//    }
//
//    @IBInspectable var sRadius:CGFloat{
//        get{
//            return layer.cornerRadius
//        }
//        set{
//            layer.shadowRadius = newValue
//        }
//    }
//
//    @IBInspectable var sColor:UIColor{
//        get{
//            return UIColor.clear
//        }
//        set{
//            layer.shadowColor = newValue.cgColor
//        }
//    }
//
//    func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//        return mask
//    }
//}

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    func addEdgeConstraints(view: UIView?, isBottomAnchor: Bool = false) {
        guard let view = view else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomA = isBottomAnchor ? bottomAnchor : safeBottomAnchor
        
        NSLayoutConstraint.activate([
            self.safeTopAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            bottomA.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }
    
}

extension String {
    var localized: String {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "en", ofType: "lproj"), let bundal = Bundle(path: path) {
            return bundal.localizedString(forKey: self, value: "", table: "Localizable")
        }
        return self
        //fatalError("Key Not Found")
    }
}

extension UITableView {
    
    func registerNibCollectionCell(nibName:String,reuseIdentifier:String){
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidthVw: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColorVW: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    
    
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.1).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 8
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
extension UITextField {
    
    func addRightPasswordView() {
        
        let rightView = UIButton(frame: .init(x: 0, y: 0, width: 24, height: 24))
        rightView.setImage(#imageLiteral(resourceName: "eyeUnActive"), for: .normal)
        rightView.setImage(#imageLiteral(resourceName: "eyeActive"), for: .selected)
        rightView.addTarget(self, action: #selector(showPassword(_:)), for: .touchUpInside)
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc private func showPassword(_ button: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        button.isSelected = !button.isSelected
    }
    
    //    func addBottomLine() {
    //        ez.dispatchDelay(0.001) {
    //            [weak self] in
    //            guard let self = self else { return }
    //
    //            let border = CALayer()
    //            border.borderColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.3).cgColor
    //            border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: self.frame.size.height)
    //            border.borderWidth = CGFloat(1.0)
    //            self.layer.addSublayer(border)
    //            self.layer.masksToBounds = true
    //        }
    //    }
    
    func addRightView(image: UIImage)
    {
        self.rightView = UIImageView(image: image)
        self.rightViewMode = .always
    }
    
    func addLeftView(image: UIImage) {
        let img = UIImageView(image: image)
        img.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        img.contentMode = .scaleAspectFit
        
        let imgV = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        imgV.addSubview(img)
        img.center = imgV.center
        
        self.leftView = imgV
        self.leftViewMode = .always
    }
    
    //    func addLabelToRightView(text: String) {
    //        let label = UILabel()
    //        label.text = text
    //        let font = UIFont(name: FontName.montserrarRegular.rawValue, size: 12.0) ?? UIFont()
    //        var widths: CGFloat = 30.0
    //         let size = text.textSize(font: font)
    //            widths = size.width + 2.0
    //        label.frame = CGRect(x: 0, y: 0, width: widths, height: 14.0)
    //        label.textColor = UIColor.gray
    //        label.font = font
    //        self.rightView = label
    //        self.rightViewMode = .always
    //    }
    //    func addBottomLineAndRightDropDownView() {
    //        ez.dispatchDelay(0.001) {
    //            [weak self] in
    //            guard let self = self else { return }
    //
    //            let border = CALayer()
    //            border.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1).cgColor
    //            border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: self.frame.size.height)
    //            border.borderWidth = CGFloat(1.0)
    //            self.layer.addSublayer(border)
    //        }
    //
    //        self.layer.masksToBounds = true
    //        self.rightView = UIImageView(image: #imageLiteral(resourceName: "dropDown"))
    //        self.rightViewMode = .always
    //    }
}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0.0
        for cell in 0 ..< cells.count {
            //            if cell % 2 == 0 {
            cells[cell].transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            //            } else {
            //                cells[cell].transform = CGAffineTransform(translationX: self.bounds.size.width, y: cells[cell].bounds.height)
            //            }
            
        }
        for cell in cells {
            UIView.animate(withDuration: 2.0, delay: 0.2 * Double(delayCounter),usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .transitionCurlUp, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            //delayCounter += 1
            delayCounter = delayCounter + 0.5
        }
    }
}



extension UIView {
    
    // ->1
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: Direction = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
        
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
}

extension UIViewController {
    
    //    func ShowBottomAlert(text:String) {
    //
    //        let snackbar = TTGSnackbar(message: text, duration: .middle)
    //        snackbar.backgroundColor = UIColor.snackBarBGColor
    //        snackbar.messageTextColor =  UIColor.NewAppBGColor
    //        snackbar.messageTextFont = /UIFont(name: Fonts.NunitoSans.Bold, size: 14.0)
    //        snackbar.leftMargin = 0
    //        snackbar.rightMargin = 0
    //        snackbar.bottomMargin = 0
    //       // snackbar.cornerRadius = 0
    //        snackbar.show()
    //    }
    
    func setSpacingButtonTextColor( _ button:UIButton , color:UIColor , spacing: CGFloat,font: UIFont ) {
        if let str = button.titleLabel?.attributedText {
            let attributedString = NSMutableAttributedString( attributedString: str  )
            // attributedString.removeAttribute(.foregroundColor, range: NSRange.init(location: 0, length: attributedString.length))
            attributedString.addAttributes(
                [.foregroundColor : color,
                 .kern : spacing,
                 .font:font
                ],
                range: NSRange.init(location: 0, length: attributedString.length)
            )
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

func showActivityIndicator(view: UIView, targetVC: UIViewController) {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
    // activityIndicator.backgroundColor = UIColor.NewTextBG
    view.backgroundColor = UIColor.white
    activityIndicator.layer.cornerRadius = 6
    activityIndicator.center = targetVC.view.center
    activityIndicator.hidesWhenStopped = true
    if #available(iOS 13.0, *) {
        activityIndicator.style = UIActivityIndicatorView.Style.large
    } else {
        // Fallback on earlier versions
    }
    activityIndicator.tag = 1
    view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
}

func hideActivityIndicator(view: UIView) {
    let activityIndicator = view.viewWithTag(1) as? UIActivityIndicatorView
    activityIndicator?.stopAnimating()
    activityIndicator?.removeFromSuperview()
    UIApplication.shared.endIgnoringInteractionEvents()
}


import Foundation
extension Notification.Name {
    static let ImagePicker = Notification.Name("ImagePicker")
    
}

