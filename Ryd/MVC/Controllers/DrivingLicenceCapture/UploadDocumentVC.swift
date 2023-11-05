//
//  UploadDocumentVC.swift
//  Ryd Driver
//
//  Created by Prepladder on 26/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class UploadDocumentVC: UIViewController {
    
    @IBOutlet weak var vwImagePreview: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCaptureImage: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var base64Str = ""
    var objApi = ApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
       // addBackButton(str: "")
        makeborder(sender: btnSave)
    }
    
    @IBAction func captureImageBtnAction(_ sender: Any) {
        self.cellTappedMethod()
    }
    
    
    
}

extension UploadDocumentVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func cellTappedMethod(){
        
        
        let alert = UIAlertController(title: "Select From", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        //        if self.isGalleryEnable {
        //            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
        //                self.openGallery()
        //            }))
        //        }
        
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
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let editedImage = info[UIImagePickerControllerEditedImage.rawValue] as? UIImage {
//            // do code if user edit his/her pic
//            imgVw.contentMode = .scaleToFill
//            imgVw.image = editedImage
//        } else if let originalimage = info[UIImagePickerControllerOriginalImage.rawValue] as? UIImage {
//            // do code if user upload new image
//            imgVw.contentMode = .scaleToFill
//            imgVw.image = originalimage
//            
//            
//        }
//        
//        let imageData:NSData = (/imgVw.image).jpegData(compressionQuality: 0.5)! as NSData
//        self.base64Str = imageData.base64EncodedString(options: .lineLength64Characters)
//        print(base64Str)
//        
//        picker.dismiss(animated: true)
//    }
    
    
    //    func validation()-> Bool{
    //        let baseStr = self.base64Str
    //        if drivingLicenceUploadfront == false {
    //            if baseStr == "" {
    //                self.view.makeToast(AlertMessage.emptyDrivingLicencefront.localized, duration: 3.0, position: .bottom)
    //                return false
    //            }
    //        } else if drivingLicenceUploadBack == false {
    //            let baseStr = self.base64Str
    //
    //            if baseStr == "" {
    //                self.view.makeToast(AlertMessage.emptyDrivingLicencefront.localized, duration: 3.0, position: .bottom)
    //                return false
    //            }
    //        } else if uploadInsuranceImage == false {
    //            let baseStr = self.base64Str
    //
    //            if baseStr == "" {
    //                self.view.makeToast(AlertMessage.emptyInsuranceProff.localized, duration: 3.0, position: .bottom)
    //                return false
    //            }
    //        } else if uploadVehicleRegImage == false {
    //            let baseStr = self.base64Str
    //
    //            if baseStr == "" {
    //                self.view.makeToast(AlertMessage.emptyVehicleRegPicture.localized, duration: 3.0, position: .bottom)
    //                return false
    //            }
    //        }
    //
    //        return true
    //    }
    
    
    func callApiUploadDrivingImageFirst(apiName:String){
        let params = [
            "title": /lblTitle.text,
            "file": "data:image/jpeg;base64," + self.base64Str
        ] as [String : Any]
        
        print("Licence first PARAMS => ", params)
        
        
        self.objApi.drivingLicenceUploadFront(apiName: apiName, parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(LicenceFrontUploadResponse.self, from: /response.data)
                    print(loginResponse)
                    if loginResponse.status == true {
                        
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
