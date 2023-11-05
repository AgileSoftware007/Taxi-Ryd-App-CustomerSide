//
//  StripeWebView.swift
//  Ryd
//
//  Created by Harsh on 05/08/21.
//

import UIKit
import WebKit

class StripeWebView: UIViewController,WKNavigationDelegate {

    var webView: WKWebView!
//    var stripeURL = "https://nowryd.com/public/stripe/account-linking?token=blabla---LOGIN-TOKEN"
    var stripeURL = "\(ApiManager().BASE_URL)stripe/account-linking?token=blabla---LOGIN-TOKEN"
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()

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
    
    func initialSetup(){
        
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor.darkGray
        
        webView.navigationDelegate = self
        //webView.loadHTMLString(/objTermsReponse?.page?.pageDescription, baseURL: nil)
      //  webView.loadFileURL(<#T##URL: URL##URL#>, allowingReadAccessTo: <#T##URL#>)
        
       // view.addSubview(label)
        view.addSubview(webView)
        

        
    }
  
}


