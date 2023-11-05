
//
//  ApiManager.swift
//  Revive
//
//  Created by MacBook on 10/06/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Alamofire

class ApiManager {
    
    //let BASE_URL = "http://new.nowryd.com/public/"
//    let BASE_URL = "https://nowryd.com/public/"
//	let BASE_URL = "http://167.99.119.160/"
	let BASE_URL = "http://159.89.191.168/"

    
    let token = UDManager.value(forKey: UDKeys.BEARER_TOKEN)
    
    let header : HTTPHeaders = ["Authorization":"Bearer " + BARRERTOKEN,"Content-Type":"application/json"]
    
    
    let signUPheader : HTTPHeaders = ["Content-Type":"application/json"]
    
    func sendMessage(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void) {
        Alamofire.request(BASE_URL + API_NAME.sendMessage, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }

    }
    
    func loginAPI(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.LOGIN)
        var header = header
            header.removeValue(forKey: "Authorization")
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.LOGIN, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func signUpAPI(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.SIGNUP)
        Alamofire.request(BASE_URL + API_NAME.SIGNUP, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: signUPheader).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func editProfile(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.EDIT_PROFILE)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.EDIT_PROFILE, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func otpAuth(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.OTP_AUTH)
        print("HEADER => ",signUPheader)
        Alamofire.request(BASE_URL + API_NAME.OTP_AUTH, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: signUPheader).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func saveAddress(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.SAVE_ADDRESS)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.SAVE_ADDRESS, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func forgotPassword(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.FORGOT_PASSWORD)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.FORGOT_PASSWORD, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func recoverPassword(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.RECOVER_PASSWORD)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.RECOVER_PASSWORD, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func drivingLicenceUploadFront(apiName: String, parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL + apiName)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + apiName, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func termsConditions(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.TERM_CONDITIONS)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.TERM_CONDITIONS, method: .get, encoding: JSONEncoding.default, headers: signUPheader).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func uploadProfilePic(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.UPLOAD_PROFILE_PIC)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.UPLOAD_PROFILE_PIC, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func forgotPaswordVerify(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.FORGOT_PASSWORD_VERIFY)
        print("HEADER => ",signUPheader)
        Alamofire.request(BASE_URL + API_NAME.FORGOT_PASSWORD_VERIFY, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: signUPheader).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func changePassword(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.CHANGE_PASSWORD)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.CHANGE_PASSWORD, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            print(response.response?.statusCode)
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
            
        }
    }
    
    func updateEmail(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.UPDATE_EMAIL)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.UPDATE_EMAIL, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            print(response.response?.statusCode)
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
            
        }
    }
    
    func getFavorites(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.FAVORITE_LOCATIONS)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.FAVORITE_LOCATIONS, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func addFavorites(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.FAVORITE_LOCATIONS)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.FAVORITE_LOCATIONS, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func deleteFavorites(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.FAVORITE_LOCATIONS)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.FAVORITE_LOCATIONS, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func getStates(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.GET_STATES)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.GET_STATES, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func updatePhoneNumber(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.UPDATE_PHONENUMBER)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.UPDATE_PHONENUMBER, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            print(response.response?.statusCode)
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
            
        }
    }
    
    func saveCardInfo(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.CREATE_CARD)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.CREATE_CARD, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func getLanguages(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.GET_LANGUAGES)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.GET_LANGUAGES, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    
    func savePreffrence(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.SAVE_PREFRENCES)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.SAVE_PREFRENCES, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    
    func getHelpCategories(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.GET_HELP_CATEGORIES)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.GET_HELP_CATEGORIES, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func saveHelp(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.SAVE_HELP_REQUEST)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.SAVE_HELP_REQUEST, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func paymentCharge(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.PAYMENT_CHARGE)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.PAYMENT_CHARGE, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
    func getCustomerPastTrips(parameters: Parameters, completion: @escaping(DataResponse<Any>) ->Void){
        print("API NAME => ",BASE_URL+API_NAME.CUSTOMER_PAST_TRIP)
        print("HEADER => ",header)
        Alamofire.request(BASE_URL + API_NAME.CUSTOMER_PAST_TRIP, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 403 {
                SocketIOManager.sharedInstance.closeConnection()
                let vc = ViewController.getVC(.main)
                let window = UIApplication.shared.windows.first
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve
                UDManager.setValue(false, forKey: UDKeys.IS_LOGGED_IN)
                nav.view.makeToast(TitleType.sessionExpired.localized, duration: 3.0, position: .bottom)
                //UIApplication.shared.delegate?.window!?.rootViewController?.present(nav, animated: true, completion: nil)
                window?.rootViewController = nav
            }else {
                completion(response)
            }
        }
    }
    
}

