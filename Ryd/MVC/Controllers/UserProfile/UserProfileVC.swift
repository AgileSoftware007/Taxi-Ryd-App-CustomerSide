//
//  UserProfileVC.swift
//  DriverApp
//
//  Created by Harsh on 12/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var vwImagePreview: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    var base64Str = ""
    var objApi = ApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.addBackButton()
        makeborder(sender: btnSave)
        makeborder(sender: btnCancel)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if validation(){
            if Reachability.isConnectedToNetwork(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.callApiUploadProfilePic()
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
        }
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func captureImageBtnAction(_ sender: Any) {
        cellTappedMethod()
    }
    
    func validation()-> Bool{
        let baseStr = self.base64Str
        if baseStr == "" {
            self.view.makeToast(AlertMessage.selectPicture.localized, duration: 3.0, position: .bottom)
            return false
        }
        return true
    }
}

extension UserProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func cellTappedMethod(){
        
        
        let alert = UIAlertController(title: "Choose Profile Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallery()
//        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK:-- ImagePicker delegate
    
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let editedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
//            // do code if user edit his/her pic
//            imgVw.contentMode = .scaleToFill
//            imgVw.image = editedImage
//        } else if let originalimage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
//            // do code if user upload new image
//            imgVw.contentMode = .scaleToFill
//            imgVw.image = originalimage
//
//        }
//
//        let imageData:NSData = (/imgVw.image).jpegData(compressionQuality: 0.5)! as NSData
//        self.base64Str = imageData.base64EncodedString(options: .lineLength64Characters)
//        print(base64Str)
//
//        picker.dismiss(animated: true)
//
//
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
            // do code if user edit his/her pic
            imgVw.contentMode = .scaleToFill
            imgVw.image = editedImage
        } else if let originalimage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            // do code if user upload new image
            imgVw.contentMode = .scaleToFill
            imgVw.image = originalimage
            
        }
        
        
        let img = imgVw.image?.fixedOrientation()
        
        let imageData:NSData = (/img).jpegData(compressionQuality: 0.5)! as NSData
//        let imageData:NSData = (/imgVw.image).jpegData(compressionQuality: 0.5)! as NSData
        self.base64Str = imageData.base64EncodedString(options: .lineLength64Characters)
        //print(base64Str)
        
        picker.dismiss(animated: true)
        
    }
    
    func callApiUploadProfilePic(){
        let params = [
            "title": /lblTitle.text,
            "file": "data:image/jpeg;base64," + self.base64Str
        ] as [String : Any]
        
        print("UPLOAD PROFILE PIC => ", params)
        
        
        self.objApi.uploadProfilePic(parameters: params, completion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(response)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(ProfilePictureUploadResponse.self, from: /response.data)
                    print("UPLOAD PROFILE REPONSE ",loginResponse)
                    if loginResponse.status == true {
//                        BARRERTOKEN = /loginResponse.user?.access?.token
//                        UDManager.set(/loginResponse.user?.access?.token, forKey: UDKeys.BEARER_TOKEN)
//                        UDManager.synchronize()
                        let vc = CompleteRegistrationVC.getVC(.main)
                        self.navigationController?.pushViewController(vc, animated: true)

                    } else {
                        self.view.makeToast(/loginResponse.message, duration: 3.0, position: .bottom)
                        print(/loginResponse.message)
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

extension UserProfileVC {
    @objc func addBackButton() {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  Asset.NdBackBtn.rawValue), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.appColor
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("" , for: .normal)
        backButton.tintColor = UIColor.white
        backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.appColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.appColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.appColor
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    
    
}


