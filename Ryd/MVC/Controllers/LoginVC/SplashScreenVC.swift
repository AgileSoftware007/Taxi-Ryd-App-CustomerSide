//
//  SplashScreenVC.swift
//  DriverApp
//
//  Created by Prepladder on 22/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            
            let loggedIn = UDManager.value(forKey: UDKeys.IS_LOGGED_IN) as? Bool
            print("loggedIn ",loggedIn)
            if loggedIn != nil && loggedIn == true {
                self.homeVCRootViewController()
            } else {
                let vc = ViewController.getVC(.main)
                self.navigationController?.setViewControllers([vc], animated: true)
            }
            //            if let savedPerson = UDManager.object(forKey: UDKeys.LOGIN_INFO) as? Data {
            //                let decoder = JSONDecoder()
            //                if let loadedPerson = try? decoder.decode(LoginResponse.self, from: savedPerson) {
            //                    print(loadedPerson)
            //                    self.homeVCRootViewController()
            //                }
            //            } else {
            //                let vc = ViewController.getVC(.main)
            //                self.navigationController?.pushViewController(vc, animated: true)
            //            }
            
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func homeVCRootViewController(){
        let vc = HomeVC.getVC(.main)
        //        let window = UIApplication.shared.windows.first
        //        let nav = UINavigationController(rootViewController: vc)
        //        nav.modalPresentationStyle = .overFullScreen
        //        nav.modalTransitionStyle = .crossDissolve
        //        window?.rootViewController?.present(nav, animated: true, completion: nil)
        
        let navCtrl = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = navCtrl
    }
    
    
    
    
}
