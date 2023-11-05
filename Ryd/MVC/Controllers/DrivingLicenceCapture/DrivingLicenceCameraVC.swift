//
//  DrivingLicenceCameraVC.swift
//  DriverApp
//
//  Created by Harsh on 12/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class DrivingLicenceCameraVC: UIViewController {
    
    @IBOutlet weak var vwImagePreview: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCaptureImage: UIButton!
    @IBOutlet weak var imgVw: UIImageView!
    var base64Str = ""
    var drivingLicenceUploadfront = false
    var uploadInsuranceImage = false
    var uploadVehicleRegImage = false
    var drivingLicenceUploadBack = false
    var objApi = ApiManager()
    var isGalleryEnable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackButton(str: "")
        self.makeborder(sender: btnSave)
        self.makeborder(sender: btnCancel)
        
        setdata()
    }
    
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if validation() {
            
            if Reachability.isConnectedToNetwork(){
                showActivityIndicator(view: self.view, targetVC: self)
                if drivingLicenceUploadfront == false {
                    callApiUploadDrivingImageFirst(apiName: API_NAME.DRIVING_LICENCE_UPLOAD_FRONT)
                } else if drivingLicenceUploadBack == false {
                    callApiUploadDrivingImageFirst(apiName: API_NAME.DRIVING_LICENCE_UPLOAD_BACK)
                } else if uploadInsuranceImage == false {
                    callApiUploadDrivingImageFirst(apiName: API_NAME.INSURANCE_PROOF)
                } else if uploadVehicleRegImage == false {
                    callApiUploadDrivingImageFirst(apiName: API_NAME.VEHICLE_REGISTRATION)
                }
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
        self.cellTappedMethod()
    }
    
    func setdata(){
        if drivingLicenceUploadfront == false {
            lblTitle.text = AlertMessage.drivingLicenceFrontText.localized
            imgVw.image = UIImage()
        } else if drivingLicenceUploadBack == false {
            lblTitle.text = AlertMessage.drivingLicenceBackText.localized
            imgVw.image = UIImage()
        } else if uploadInsuranceImage == false {
            lblTitle.text = AlertMessage.insuranceText.localized
            imgVw.image = UIImage()
        } else if uploadVehicleRegImage == false {
            lblTitle.text = AlertMessage.vehicleRegistration.localized
            imgVw.image = UIImage()
        }
    }
    
}
extension DrivingLicenceCameraVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func cellTappedMethod(){
        
        
        let alert = UIAlertController(title: "Select From", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        if self.isGalleryEnable {
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))
        }

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
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            // do code if user edit his/her pic
            imgVw.contentMode = .scaleToFill
            imgVw.image = editedImage
        } else if let originalimage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            // do code if user upload new image
            imgVw.contentMode = .scaleToFill
            imgVw.image = originalimage
            
            
        }
        
        let imageData:NSData = (/imgVw.image).jpegData(compressionQuality: 0.5)! as NSData
        self.base64Str = imageData.base64EncodedString(options: .lineLength64Characters)
        print(base64Str)
        
        picker.dismiss(animated: true)
    }
    
    
    func validation()-> Bool{
        let baseStr = self.base64Str
        if drivingLicenceUploadfront == false {
            if baseStr == "" {
                self.view.makeToast(AlertMessage.emptyDrivingLicencefront.localized, duration: 3.0, position: .bottom)
                return false
            }
        } else if drivingLicenceUploadBack == false {
            let baseStr = self.base64Str
            
            if baseStr == "" {
                self.view.makeToast(AlertMessage.emptyDrivingLicencefront.localized, duration: 3.0, position: .bottom)
                return false
            }
        } else if uploadInsuranceImage == false {
            let baseStr = self.base64Str
            
            if baseStr == "" {
                self.view.makeToast(AlertMessage.emptyInsuranceProff.localized, duration: 3.0, position: .bottom)
                return false
            }
        } else if uploadVehicleRegImage == false {
            let baseStr = self.base64Str
            
            if baseStr == "" {
                self.view.makeToast(AlertMessage.emptyVehicleRegPicture.localized, duration: 3.0, position: .bottom)
                return false
            }
        }
        
        return true
    }
    
    
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
                        self.base64Str = String()
                        if loginResponse.document?.slug == slugDrivingFront {
                            self.drivingLicenceUploadfront = true
                        } else if loginResponse.document?.slug == slugDrivingBack {
                            self.drivingLicenceUploadBack = true
                            self.isGalleryEnable = true
                        }  else if loginResponse.document?.slug == slugInsurance {
                            self.uploadInsuranceImage = true
                        } else if loginResponse.document?.slug == slugVehicleRegistration {
                            self.uploadVehicleRegImage = true
                            let vc = UserProfileVC.getVC(.main)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        self.setdata()
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
