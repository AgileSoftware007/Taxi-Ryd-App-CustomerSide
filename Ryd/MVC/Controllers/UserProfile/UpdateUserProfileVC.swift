//
//  UpdateUserProfileVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 07/05/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class UpdateUserProfileVC: UIViewController {

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

      //  addBackButton(str: "")
        self.makeborderr(sender: btnSave)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func makeborderr(sender: UIButton){
           sender.layer.cornerRadius = 12
           sender.layer.masksToBounds = true
           sender.layer.borderWidth = 2.0
           sender.layer.borderColor = UIColor.appColor.cgColor
       }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if validation(){
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                self.callApiUploadProfilePic()
            }else {
                print(AlertMessage.noInternet.localized)
                self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
            }
        }
        
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

extension UpdateUserProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
//     private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
            imgVw.image = editedImage
        } else if let originalimage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            // do code if user upload new image
            imgVw.image = originalimage

        }
        imgVw.contentMode = .scaleToFill

        let imageData:NSData = (/imgVw.image).jpegData(compressionQuality: 0.5)! as NSData
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
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(ProfilePictureUploadResponse.self, from: /response.data)
                    //print(loginResponse)
                    if loginResponse.status == true {
//                        BARRERTOKEN = /loginResponse.user?.access?.token
//                        UDManager.set(/loginResponse.user?.access?.token, forKey: UDKeys.BEARER_TOKEN)
//                        UDManager.synchronize()
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UDManager.set(encoded, forKey: UDKeys.LOGIN_INFO)
                            UDManager.synchronize()
                        }
                        let alert = UIAlertController(title: "", message: loginResponse.message, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            //self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)

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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
