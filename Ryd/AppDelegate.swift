//
//  AppDelegate.swift
//  Ryd
//
//  Created by Harsh on 23/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseCore
import Firebase
import GooglePlaces
import GoogleMaps
import SocketIO

@main
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    
    
    var window: UIWindow?
    var googleMapServiceKey = "AIzaSyAHuv4YLA1Rujy3-uNLCis_gBaIW4huF5g"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        getFcmToken(application)
        
        GMSPlacesClient.provideAPIKey(googleMapServiceKey)
        GMSServices.provideAPIKey(googleMapServiceKey)
        let token = UDManager.value(forKey: UDKeys.BEARER_TOKEN) as? String
        print("TOKEN ",token)
        if token != nil {
            BARRERTOKEN = /token
        } else {
            BARRERTOKEN = "0zoeEfiPCRqq8r3Q6T26sPiocRCYiaE2PRkgfCmZmvRg4TtjnrC80MXMPXCNQmEJ"
        }
        
        SocketIOManager.sharedInstance.establishConnection()
        
        return true
    }
    
    func getFcmToken(_ application: UIApplication){
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                print(DEVICE_NAME)
                print(DEVICE_MODEL)
                print(DEVICE_SYSTEM_VERSION)
                UDManager.set(token, forKey: UDKeys.FCM_TOKEN)
                UDManager.synchronize()
            }
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketIOManager.sharedInstance.closeConnection()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.sharedInstance.establishConnection()
    }
}
