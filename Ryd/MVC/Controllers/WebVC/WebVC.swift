//
//  WebVC.swift
//  DriverApp
//
//  Created by Harsh on 19/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKNavigationDelegate {
    
   
    var objTermsReponse: TermsConditionsResponse?
    var label: UILabel!
    var webView: WKWebView!
//    var str = "<p>Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. v</p>\r\n\r\n<p>Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit. Lorem ppsum&nbsp; dolor sit emit.</p>"
    
    let objApimanager = ApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork(){
            showActivityIndicator(view: self.view, targetVC: self)
            callLoginApi()
        }else {
            print(AlertMessage.noInternet.localized)
            self.view.makeToast(AlertMessage.noInternet.localized, duration: 3.0, position: .bottom)
        }
    }
    
    func initialSetup(){
        
        addWebBackButton(text: /objTermsReponse?.page?.title)
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.lightGray
        label.text = /objTermsReponse?.page?.title
        
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor.darkGray
        
        webView.navigationDelegate = self
        webView.loadHTMLString(/objTermsReponse?.page?.pageDescription, baseURL: nil)
        
        view.addSubview(label)
        view.addSubview(webView)
        
        // horizontal constraints
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[label]|", options: [], metrics: nil, views: ["label": label]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        
        // vertical constraints
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label][webView]|", options: [], metrics: nil, views: ["label": label, "webView": webView]))
        
    }
    
  
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("didFinish")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("didFail")
    }
}

extension WebVC {
    
    func callLoginApi(){
        let token = UDManager.value(forKey: UDKeys.FCM_TOKEN) as? String
        
        let params = [
            "country_code": CountryCode,
            "phonenumber": "",
            "password": "",
            "device_id": /DEVICE_ID,
            "device_type" : DEVICE_TYPE,
            "device_name" : DEVICE_NAME,
            "fcm_token": /token,
            "user_type" : USER_TYPE
        ] as [String : Any]
        
        print("LOGIN PARAMS => ", params)
        
        
        self.objApimanager.termsConditions(parameters: params, completion: { (response) in
            hideActivityIndicator(view: self.view)
            print(response.result.value)
            switch(response.result) {
            case .success(_):
                do {
                    let loginResponse = try JSONDecoder().decode(TermsConditionsResponse.self, from: /response.data)
                    self.objTermsReponse = loginResponse
                    if loginResponse.status == true {
                        self.initialSetup()
                    } else {
                        self.view.makeToast(loginResponse.message, duration: 3.0, position: .bottom)
                        
                    }

                } catch let error as NSError {
                    self.view.makeToast("Something went wrong", duration: 3.0, position: .bottom)
                    print("Failed to load: \(error.localizedDescription)")
                }
                break
            case .failure(_):
                self.view.makeToast("Something went wrong", duration: 3.0, position: .bottom)
                print("response.result.error ",response.result.error as Any)
                break
            }
            
        })
    }
}
