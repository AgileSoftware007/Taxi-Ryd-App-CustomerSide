//
//  BaseVC.swift
//  DriverApp
//
//  Created by Prepladder on 22/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import SocketIO

protocol ImagePicker: class {
    func pickImageFromPicker(image: UIImage)
}


class BaseVC: UIViewController {
    weak var delegate: ImagePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension BaseVC :  UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func cellTappedMethod(){
        
        let vc = UpdateUserProfileVC.getVC(.home)
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let alert = UIAlertController(title: "Select From", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            self.openCamera()
//        }))
//
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallery()
//        }))
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//
//
//        if let popoverController = alert.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//
//        self.present(alert, animated: true, completion: nil)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var img = UIImage()
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            // do code if user edit his/her pic
            //imgVw.contentMode = .scaleToFill
            //imgVw.image = editedImage
            img = editedImage
        } else if let originalimage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            // do code if user upload new image
            // imgVw.contentMode = .scaleToFill
            //imgVw.image = originalimage
            img = originalimage
        }
        
        //        let imageData:NSData = UIImageJPEGRepresentation(/imgVw.image, 0.5)! as NSData
        //        self.base64Str = imageData.base64EncodedString(options: .lineLength64Characters)
        //        print(base64Str)
        
        picker.dismiss(animated: true) {
            NotificationCenter.default.post(name: .ImagePicker, object: nil, userInfo: ["imgName":img])
        }
    }
}

