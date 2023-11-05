//
//  HomeVC.swift
//  DriverApp
//
//  Created by Harsh on 09/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import AVFoundation
import Alamofire
import SwiftyJSON
import GooglePlaces
import SDWebImage
import CircleProgressView

enum TextType : String {
    case source = "Source"
    case destination = "Destination"
}

struct Destination {
    var address : String?
    var lat : String?
    var lng : String?
}

class PriceColVwCell : UICollectionViewCell {
    @IBOutlet weak var lblPriceLarge: UILabel!
    @IBOutlet weak var lblTitleLarge: UILabel!
    @IBOutlet weak var lblDescLarge: UILabel!
}

class HomeVC: UIViewController, CLLocationManagerDelegate,OnlineUpdate,FinishTrip {
    func onlinestatus() {
        
    }
    
    
    
    
    var objOTPAuthResponse : OTPAuthResponse?
    var objLoginResponse : LoginResponse?
    var objApi = ApiManager()
    var locationManager = CLLocationManager()
    var objRoute : RouteModel?
    var objDriver : Driver?
    var textType = ""
    var objSocketResponse = [SocketModel]()
    var carListArray = [FindServiceResponse]()
    var arryStops = NSMutableArray()
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    var sourceCoordinates : CLLocationCoordinate2D?
    var destinationCoordinates : CLLocationCoordinate2D?
    var destinationArray = NSMutableArray()
    
    @IBOutlet weak var BtnMenu: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwBottomOnlineStatus: UIView!
    @IBOutlet weak var vwTopDirection: UIView?
    @IBOutlet weak var bottomPickupRideStackView: UIStackView?
    @IBOutlet weak var vwBottomPickUPinformation: UIView?
    @IBOutlet weak var vwBottomRiderInformation: UIView!
    @IBOutlet weak var vwTopHeight: NSLayoutConstraint?
    @IBOutlet weak var vwBottomOnlineHeight: NSLayoutConstraint!
    @IBOutlet weak var vwTopSearchLocation: UIView!
    
    @IBOutlet weak var lblReachTimeDistance: UILabel!
    @IBOutlet weak var lblPickUPAddress: UILabel!
    @IBOutlet weak var lblRiderName: UILabel!
    @IBOutlet weak var lblCurrentLocationName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgVwRider: UIImageView!
    
    
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var tblCarList: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var vwProgress: CircleProgressView!
    
    @IBOutlet weak var vwFetchRide: UIView!
    @IBOutlet weak var vwDriverInfo: UIView!
    @IBOutlet weak var vwConfirmCancelTrip: UIView!
    @IBOutlet weak var vwDropOffInfo: UIView!
    @IBOutlet weak var vwCarlist: UIView!
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var imgVwProgress: UIImageView!
    
    @IBOutlet weak var lblOutSide: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblCarNumber: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var imgVwDriver: UIImageView!
    @IBOutlet weak var imgVwCar: UIImageView!
    
    @IBOutlet weak var vwWaitingTimer: UIView!
    @IBOutlet weak var lblWaitingTimer: UILabel!
    
    
    @IBOutlet weak var lblFirstStop: UILabel!
    @IBOutlet weak var lblEndStop: UILabel!
    
    var tripRiderMarker: GMSMarker?
    
    var rightSide = false
    var leftSide = true
    var isRiderInfoExpand = false
    var isUserOnline = false
    var selectedRow = -1
    
    //MARK:- Audio
    var gameTimer: Timer?
    var audioPlayer = AVAudioPlayer()
    var waitingTimer: Timer?
    var waitTime = 0
    
    //MARK:- Count Down Progress
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft = 0
    var endTime: Date?
    var timer: Timer?
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    @IBOutlet weak var tblVwStops: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        setOnline()
        
        UDManager.set(true, forKey: UDKeys.IS_LOGGED_IN)
        txtSource.delegate = self
        txtDestination.delegate = self
        
        NotificationCenter.default.addObserver(self,selector: #selector(getCarlistfromServer(_:)),name: .showDriverCar,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(removeCarfromServer(_:)),name: .removeCar,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(carlists(_:)),name: .carLists,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(acceptRide(_:)),name: .acceptRide,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(declineRide(_:)),name: .declineRide, object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(outSideDriver(_:)),name: .outSideDriver, object: nil)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(showndRideCars(_:)),name: .showndRideCars, object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(startWaiting(_:)),name: .startWaiting,object: nil)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(startDestination(_:)),name: .startDestination,object: nil)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(endWaiting(_:)),name: .endWaiting,object: nil)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(endDestination(_:)),name: .endDestination,object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(endTrip(_:)),name: .endTrip,object: nil)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(cancelRyd(_:)),name: .cancelRyd,object: nil)
        
        
        NotificationCenter.default.addObserver(self,selector: #selector(updateHiredDriverLocation(_:)),name: .updateDriverLocation, object: nil)
        
        
        vwBottomOnlineStatus.isHidden = true
        vwBottomOnlineHeight.constant = 0
        
        self.userNotificationCenter.delegate = self
        
        requestNotificationAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.startUpdatingLocation()
        print("call Will APpear")
        createGoogleMap()
        initialSetup()
        self.navigationController?.navigationBar.isHidden = true

        self.getAddress(lat: /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude) { (address) in
            var addStr : String?
            addStr = address[0] as? String
            self.txtSource.text = addStr
            var lat : CLLocationDegrees?
            var lng : CLLocationDegrees?
            lat = address[1] as? CLLocationDegrees
            lng = address[2] as? CLLocationDegrees
            self.sourceCoordinates = CLLocationCoordinate2D(latitude: lat ?? .zero, longitude: lng ?? .zero)
            self.arryStops.add(/addStr)
            self.tblCarList.reloadData()
        }
        NotificationCenter.default.addObserver(self,selector: #selector(messageReceived(_:)),name: .messageReceived, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .messageReceived, object: nil)
    }

    @objc func updateHiredDriverLocation(_ notification: Notification) {
        let dataArray = notification.userInfo?["userInfo"] as? [Dictionary<String, Any>]
        guard let model = dataArray?.first?.decodeTo(classType: UpdateRiderLocation.self).model else { return }
        guard let riderId = objDriver?.id else { return }
        //        guard let marker = getDriverMarker(id: riderId) else { return }
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model.driver?.lat) ?? CLLocationDegrees(), longitude: CLLocationDegrees(/model.driver?.lng) ?? CLLocationDegrees())
        
        if tripRiderMarker == nil, (tripRiderMarker?.userData as? String) != "\(riderId)" {
            tripRiderMarker = GMSMarker()
            tripRiderMarker?.position = coordinates
            tripRiderMarker?.icon = UIImage(named: "Ic_DriverCar")
            tripRiderMarker?.map = self.mapView
            tripRiderMarker?.userData = riderId
            tripRiderMarker?.appearAnimation = .pop
        }
        else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            tripRiderMarker?.position =  coordinates
            if tripRiderMarker?.map == nil {
                tripRiderMarker?.map = self.mapView
            }
            CATransaction.commit()
        }
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    
    @objc func startDestination(_ notification: Notification){
        
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            
            
            print(" Start Destination ",dataArray as Any)
            
            
            vwDriverInfo.removeFromSuperview()
            self.waitingTimer?.invalidate()
            self.waitingTimer = nil
            self.vwWaitingTimer.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5,
                           delay: 0, usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseIn, animations: {
                self.vwDropOffInfo.frame = CGRect(x: 0, y: self.view.frame.height - 260 , width: self.view.frame.width, height: 250)
                self.view?.addSubview(self.vwDropOffInfo)
            }, completion: nil)
            
            
            let dict = dataArray?[0] as? NSDictionary
            let driverId = dict?.value(forKey: "id") as? String
            let driverLat = dict?.value(forKey: "lat") as? String
            let driverLong = dict?.value(forKey: "lng") as? String
            let firstStop = dict?.value(forKey: "address") as? String
            
            let source = CLLocationCoordinate2D(latitude: self.locationManager.location?.coordinate.latitude ?? .zero, longitude: self.locationManager.location?.coordinate.longitude ?? .zero)
            let destination = CLLocationCoordinate2D(latitude: CLLocationDegrees(/driverLat) ?? CLLocationDegrees(), longitude: CLLocationDegrees(/driverLong) ?? CLLocationDegrees())
//            self.fetchRoute(from: source, to: destination, sourceIcon: UIImage(named: "Ic_DriverCar"))
            self.fetchRoute(from: source, to: destination)
            tripRiderMarker?.map = nil
            self.tripRiderMarker = makeSourceMarker(location: source, markerIcon: UIImage(named: "Ic_DriverCar"))
            self.tripRiderMarker?.userData = driverId
            //            markersList.append(driverMarker)
            
            lblFirstStop.text = /firstStop
            lblEndStop.text = /firstStop
            
            
        }
        
        
    }
    
    
    @objc func endDestination(_ notification: Notification){
        print("END Destination")
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            var dict = NSDictionary()
            dict = dataArray?[0] as? NSDictionary ?? ["":""]
            
            vwDriverInfo.removeFromSuperview()
            let vc = FinishTripVC.getVC(.tripDetails)
            vc.modalPresentationStyle = .fullScreen
            vc.dict = dict
            vc.objDriver = self.objDriver
            vc.delegate = self
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func startWaiting(_ notification: Notification){
        print("Start Waiting")
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            
            
        }
    }
    
    
    @objc func endWaiting(_ notification: Notification){
        print("END Waiting")
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            //self.btnStartTrip.setTitle(DriverReachStatus.Destination.rawValue, for: .normal)
            
        }
    }
    
    @objc func cancelRyd(_ notification: Notification){
        print("cancelRyd TRIP")
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        
        if /dataArray?.count > 0 {
            print("cancelRyd TRIP dataArray ",dataArray as Any)
        }
        destinationArray.removeAllObjects()
    }
    
    @objc func endTrip(_ notification: Notification){
        print("END TRIP")
        
        vwDropOffInfo.removeFromSuperview()
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            
            var dict = NSDictionary()
            dict = dataArray?[0] as? NSDictionary ?? ["":""]
            
            vwDriverInfo.removeFromSuperview()
            let vc = FinishTripVC.getVC(.tripDetails)
            vc.modalPresentationStyle = .fullScreen
            vc.dict = dict
            vc.objDriver = self.objDriver
            vc.delegate = self
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }
    }
    
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Ryd"
        notificationContent.body = "Your driver is coming outside"
        //notificationContent.badge = NSNumber(value: 3)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    @objc func messageReceived(_ notification: NSNotification) {
        let dataArray = notification.userInfo?["userInfo"] as? [String: AnyObject]
        if let model = dataArray?.decodeTo(classType: ChatMessage.self).model {
            guard model.senderId != objLoginResponse?.user?.id else { return }
            sendMessageNotification(model: model)
        }
    }
    
    func sendMessageNotification(model: ChatMessage) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Driver"
        notificationContent.body = model.message ?? "You have a new message from your driver"
        notificationContent.userInfo = model.toDictionary()
        //notificationContent.badge = NSNumber(value: 3)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "messageReceived",
                                            content: notificationContent,
                                            trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    @objc func getCarlistfromServer(_ notification: Notification){
        //print(notification.userInfo?["userInfo"] as Any)
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if dataArray?.isEmpty == false {
            self.objSocketResponse.removeAll()
        }

        for indexx in 0..<dataArray!.count {
            let objArray = dataArray?[indexx] as? NSArray
            for obj in 0..<objArray!.count {
                let dict = objArray?[obj] as? Dictionary<String, Any>
                let id = dict?["id"] as? String
                let lat = dict?["lat"] as? String
                let lng = dict?["lng"] as? String
                let distance = dict?["distance"] as? Double
                let busy = dict?["busy"] as? Int
                let socketId = dict?["socket_id"] as? String
                let socketMode = SocketModel(lng: lng, socketID: socketId, id: id, lat: lat, busy: busy == 1, distance: distance)
//                self.objSocketResponse.removeAll(where: { $0.id == id })
                self.objSocketResponse.append(socketMode)
            }
        }
        self.showDriverCars()
        
    }
    
    @objc func removeCarfromServer(_ notification: Notification){
        
        print(notification.userInfo?["userInfo"] as Any)
        
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        for indexx in 0..<dataArray!.count {
            let objArray = dataArray?[indexx] as? NSArray
            for obj in 0..<objArray!.count {
                let driverID = objArray?[obj] as? String
                self.objSocketResponse.removeAll(where: {$0.id == driverID})
            }
        }
        
        self.showDriverCars()
        
    }
    
    
    @objc func carlists(_ notification: Notification){
        let arrayCarlist = notification.userInfo?["userInfo"] as? NSArray
        self.carListArray.removeAll()
        if arrayCarlist!.count > 0 {
            vwBottomOnlineHeight.constant = 90
            vwBottomOnlineStatus.isHidden = false
            for indexx in 0..<arrayCarlist!.count {
                let objArray = arrayCarlist?[indexx] as? NSArray
                for obj in 0..<objArray!.count {
                    let dict = objArray?[obj] as? NSDictionary
                    let amountStr = dict?["amount"] as? Double
                    let distanceStr = dict?["distance"] as? Double
                    let driverIdStr = dict?["driver_id"] as? String ?? "0"
                    let idStr = dict?["id"] as? Int
                    let minutesStr = dict?["minutes"] as? Double
                    let seatsStr = dict?["seats"] as? String ?? "0"
                    let titleStr = dict?["title"] as? String
                    let imageStr = dict?["image"] as? String
                    
                    let objDict = FindServiceResponse(amount: amountStr, distance: distanceStr, minutes: minutesStr, driverID: Int(driverIdStr), id: idStr, image: imageStr, seats: Int(seatsStr), title: titleStr)
                    // print("objDict ",objDict)
                    self.carListArray.append(objDict)
                }
            }
            //            self.vwFetchRide.removeFromSuperview()
            self.vwFetchRide.isHidden = true
            self.showCarlist()
            self.tblCarList.reloadData()
        }
        
        
    }
    
    @objc func showndRideCars(_ notification: Notification){
        let arrayCarlist = notification.userInfo?["userInfo"] as? NSArray
        //  print("showndRideCars CarliSt => ", arrayCarlist)
        if arrayCarlist!.count > 0 {
            let dict = arrayCarlist?[0] as? NSDictionary
            self.dictToData(dictionaryExample: dict ?? ["":""])
        }
    }
    
    
    @objc func acceptRide(_ notification: Notification){
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            vwFetchRide.removeFromSuperview()
            //            self.vwFetchRide.isHidden = true
            let dict = dataArray?[0] as? NSDictionary
            let driverDict = dict?.value(forKey: "driver") as? NSDictionary
            let driverLat = driverDict?.value(forKey: "lat") as? String
            let driverLong = driverDict?.value(forKey: "lng") as? String
            let driverId = driverDict?.value(forKey: "id") as? String
            let destination = CLLocationCoordinate2D(latitude: /self.sourceCoordinates?.latitude, longitude: /self.sourceCoordinates?.longitude)
            let source = CLLocationCoordinate2D(latitude: CLLocationDegrees(/driverLat) ?? CLLocationDegrees(), longitude: CLLocationDegrees(/driverLong) ?? CLLocationDegrees())
            self.fetchRoute(from: source, to: destination)
            tripRiderMarker?.map = nil
            self.tripRiderMarker = makeSourceMarker(location: source, markerIcon: UIImage(named: "Ic_DriverCar"))
            self.tripRiderMarker?.userData = driverId
            //            markersList.append(driverMarker)
            self.vwTopSearchLocation.isHidden = true
            self.vwCarlist.removeFromSuperview()
            self.vwBottomOnlineStatus.isHidden = true
            self.vwBottomOnlineHeight.constant = 0
            self.showDriverInfoPopup()
        }
        
        
    }
    
    @objc func declineRide(_ notification: Notification){
        self.destinationArray.removeAllObjects()
        self.txtSource.text = ""
        self.txtDestination.text = ""
        self.sourceCoordinates = nil
        self.destinationCoordinates = nil
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            self.vwCarlist.removeFromSuperview()
            self.mapView.clear()
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    @objc func outSideDriver(_ notification: Notification){
        let dataArray = notification.userInfo?["userInfo"] as? [Any]
        if /dataArray?.count > 0 {
            sendNotification()
            
            self.lblOutSide.text = "Outside"
            
            UIView.animate(withDuration: 0.5,
                           delay: 0, usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseIn, animations: {
                self.vwWaitingTimer.frame = CGRect(x: 20, y: 230 , width: self.view.frame.width - 40, height: 210)
                self.view?.addSubview(self.vwWaitingTimer)
            }, completion: nil)
            waitingTimer?.invalidate()
            waitingTimer = nil
            waitTime = 0
            waitingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
    }
    
    @objc func onTimerFires() {
        waitTime += 1
        print("waitTime ",waitTime)
        lblWaitingTimer.text = stringFromTimeInterval(interval: TimeInterval(waitTime))
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        //let hours = (interval / 3600)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setOnline(){
        mapView.mapType = .terrain
        mapView.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func setUpCountDownProgress(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    func initialSetup() {
        if let savedPerson = UDManager.object(forKey: UDKeys.LOGIN_INFO) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginResponse.self, from: savedPerson) {
                print("loadedPerson ",loadedPerson)
                // print("loadedPerson ID ",/loadedPerson.user?.id)
                self.objLoginResponse = loadedPerson
            }
        }
    }
    
    func refreshHomeVC(){
        self.vwTopSearchLocation.isHidden = false
        self.vwBottomOnlineStatus.isHidden = false
        self.vwTopDirection?.isHidden = true
        self.vwTopHeight?.constant = 0
        self.bottomPickupRideStackView?.isHidden = true
        self.vwBottomPickUPinformation?.isHidden = true
        self.mapView.clear()
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        let vc = MenuVC.getVC(.main)
        vc.objLoginResponse = self.objLoginResponse
        /*let transition = CATransition()
         transition.duration = 0.5
         transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
         transition.type = CATransitionType.push
         transition.subtype = CATransitionSubtype.fromLeft
         self.view.window?.layer.add(transition, forKey: nil)*/
        //self.view.window!.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
    @IBAction func prefrenceBtnAction(_ sender: Any) {
        
    }
    
    func showDriverInfoPopup() {
        print("objDriver ",objDriver)
        lblDriverName.text = /objDriver?.driverFirstName
        lblCarType.text = /objDriver?.vehicleColor
        lblCarName.text = /objDriver?.vehicleBrand + " " + /objDriver?.vehicleModel
        lblCarNumber.text = "\(objDriver?.modelID)"
        let minStr: String = String(format: "%.2f", /objDriver?.minutes)
        //        lblOutSide.text = " Arriving in  \(minStr) mins"
        
        lblOutSide.text = " Arriving in \(/objDriver?.minutes?.minutesToTime())" + " mins"
        
        
        //        let imgUrl = self.objApi.BASE_URL + /self.objDriver?.vehicleImage?.medium
        //        imgVwCar.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        
        let imgUrll = self.objApi.BASE_URL + /self.objDriver?.driverImage?.medium
        imgVwDriver.sd_setImage(with: URL(string: imgUrll), placeholderImage: UIImage(named: Asset.IcDummyUser.rawValue))
        
        //        UIView.animate(withDuration: 0.5,
        //                       delay: 0, usingSpringWithDamping: 1.0,
        //                       initialSpringVelocity: 1.0,
        //                       options: .curveEaseOut, animations: {
        //                        self.vwDriverInfo.frame = CGRect(x: 0, y: self.view.frame.height - 180 , width: self.view.frame.width, height: 180)
        //                        self.view?.addSubview(self.vwDriverInfo)
        //                       }, completion: nil)
        
        
        vwDriverInfo.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 250)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [self] in
            self.vwDriverInfo.frame = CGRect(x: 0, y: self.view.frame.height - 250 , width: self.view.frame.width, height: 250)
        }) { finished in
            
        }
        self.view?.addSubview(self.vwDriverInfo)
        
        
    }
    
    
    func showFetchRidePopup(){
        
        vwFetchRide.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 250)
        vwFetchRide.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [self] in
            vwFetchRide.frame = CGRect(x: 0, y: self.view.frame.height - 250, width: self.view.frame.width, height: 250)
        }) { finished in
            
            UIView.animate(withDuration: 1.5, delay: 0, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
                self.imgVwProgress?.alpha = 0.5
            }, completion: nil)
            
        }
        self.view.addSubview(vwFetchRide)
        imgVwProgress?.layer.cornerRadius = (imgVwProgress?.frame.size.height ?? 0)/2
        imgVwProgress?.layer.masksToBounds = true
        
    }
    
    
    @IBAction func destinationBtnAction(_ sender: Any) {
        
        if selectedRow != -1 {
            vwCarlist.isHidden = true
            vwBottomOnlineHeight.constant = 0
            guard self.objLoginResponse?.user?.cards != nil else {
                cancelFetchRideBtn(sender)
                self.view.makeToast(AlertMessage.addPayment.localized, duration: 3.0, position: .bottom)
                return
            }
            self.getAddress(lat: /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude) { (address) in
                var addStr : String?
                addStr = address[0] as? String
                print("self.sourceCoordinatessssss destinationBtnAction ",self.sourceCoordinates as Any)
                SocketIOManager.sharedInstance.findRide(userId: "\(/self.objLoginResponse?.user?.id)", userLat: /self.sourceCoordinates?.latitude, userLong: /self.sourceCoordinates?.longitude, serviceID: self.selectedRow,destination: self.destinationArray, address: /addStr)
            }
            showFetchRidePopup()
        }
        else {
            self.view.makeToast(AlertMessage.noSelectCar.localized, duration: 3.0, position: .bottom)
        }
        
        
        
        
    }
    
    @IBAction func cancelConfirmAction(_ sender: Any) {
        print("cancelConfirmAction")
        
        self.getAddress(lat: /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude) { (address) in
            var addStr : String?
            addStr = address[0] as? String
            SocketIOManager.sharedInstance.cancelRyd2(tripId: "\(/self.objDriver?.tripID)", cancelBy: "customer", lat: /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude, location: /addStr)
            
        }
        
        self.mapView.clear()
        self.vwTopSearchLocation.isHidden = false
        self.destinationArray.removeAllObjects()
        self.txtSource.text = ""
        self.txtDestination.text = ""
        self.sourceCoordinates = nil
        self.destinationCoordinates = nil
        self.vwConfirmCancelTrip.removeFromSuperview()
        self.showDriverCars()
        self.createGoogleMap()
        vwDropOffInfo.removeFromSuperview()
        vwWaitingTimer.removeFromSuperview()
        waitingTimer?.invalidate()
        waitingTimer = nil
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func cancelFetchRideBtn(_ sender: Any) {
        print("cancelFetchRideBtn")
        self.txtDestination.text = ""
        //        vwFetchRide.removeFromSuperview()
        self.vwFetchRide.isHidden = true
        self.mapView.clear()
        self.createGoogleMap()
        locationManager.startUpdatingLocation()
        destinationArray.removeAllObjects()
        self.getAddress(lat: /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude) { (address) in
            var addStr : String?
            addStr = address[0] as? String
            SocketIOManager.sharedInstance.cancelRyd2(tripId: "\(/self.objDriver?.tripID)", cancelBy: "customer", lat:  /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude, location: /addStr)
            
        }
    }
    
    @IBAction func cancelRideBtn(_ sender: Any) {
        print("cancelRideBtn")
        self.vwDriverInfo.removeFromSuperview()
        self.vwConfirmCancelTrip.frame = CGRect(x: 0, y: 0 , width: self.view.frame.width - 60, height: self.view.frame.height - 100)
        self.vwConfirmCancelTrip.center = self.view.center
        self.view.addSubview(vwConfirmCancelTrip)
    }
    
    func paymentSuccess() {
        //        vwFetchRide.removeFromSuperview()
        self.vwFetchRide.isHidden = true
        vwDropOffInfo.removeFromSuperview()
        vwDriverInfo.removeFromSuperview()
//        vwProgress.removeFromSuperview()
        self.locationManager.startUpdatingLocation()
        tripRiderMarker?.map = nil
        tripRiderMarker = nil
        objDriver = nil
        timer?.invalidate()
        timer = nil
        txtDestination.text = ""
        txtSource.text = ""
        refreshHomeVC()
    }
    
    @IBAction func showRiderInfoAction(_ sender: Any) {
        // self.vwBottomRiderInformation.isHidden = false
        
        self.openNavigationMap(lat: /self.objRoute?.routes?.first?.legs?.first?.endLocation?.lat, long: /self.objRoute?.routes?.first?.legs?.first?.endLocation?.lng)
    }
    
    @IBAction func cancelRiderAction(_ sender: Any) {
        print("cancelRiderActionnnn")
        cancelRideBtn(sender)
//        let vc = CancelRIdeVC.getVC(.activity)
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chattingRiderAction(_ sender: Any) {
        openChatting(with: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        socketUserId = "\(/self.objLoginResponse?.user?.id)"

        socketUserLat = /locationManager.location?.coordinate.latitude
        socketUserLong = /locationManager.location?.coordinate.longitude
        
        SocketIOManager.sharedInstance.establishConnection()
        
        SocketIOManager.sharedInstance.emitCall(userId: "\(/objLoginResponse?.user?.id)", userLat: locationManager.location?.coordinate.latitude ?? .zero, userLong: locationManager.location?.coordinate.longitude ?? .zero)
        
        
        SocketIOManager.sharedInstance.getDriverList()
        
        SocketIOManager.sharedInstance.getOfflineDriver()
        
        SocketIOManager.sharedInstance.findServices()
        
        SocketIOManager.sharedInstance.findRides()
        
        SocketIOManager.sharedInstance.acceptRide()
        
        SocketIOManager.sharedInstance.declineRide()
        
        SocketIOManager.sharedInstance.driverOutSide()
        
        SocketIOManager.sharedInstance.cancelRyd2()
        
        SocketIOManager.sharedInstance.updateLocation()
        
        SocketIOManager.sharedInstance.startDestination()
        
        
        SocketIOManager.sharedInstance.endDestination()
        
        
        SocketIOManager.sharedInstance.endTrip()
        
        
    }
    
}
extension HomeVC {
    func createGoogleMap(){
        
        mapView.clear()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 30)
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 3.0
        locationManager.requestAlwaysAuthorization()
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func showCovidPopUP(){
        let vc = CovidVC.getVC(.main)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func openChatting(with message: ChatMessage?) {
        let vc = ChattingVC.getVC(.chatting)
        vc.baseChat = ChatMessage(tripId: objDriver?.tripID, senderId: objLoginResponse?.user?.id, receiverId: Int(/objDriver?.driverID))
        if let message {
            vc.messageList = [message]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func updateTime() {
        if timeLeft <= 10 {
            print("TIME LEFTttttt => ",timeLeft)
            self.vwProgress.progress =  Double(timeLeft / 100)
            print("TIME LEFT => ",Double(timeLeft / 100))
            timeLeft = timeLeft + 1
        } else {
            
            //            vwFetchRide.removeFromSuperview()
            self.vwFetchRide.isHidden = true
            timer?.invalidate()
            timer = nil
            self.gameTimer?.invalidate()
            self.audioPlayer.stop()
            
        }
    }
    
    @IBAction func sourceTextTapped(_ sender: Any) {
        txtSource.resignFirstResponder()
        textType = TextType.source.rawValue
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func destinationTextTapped(_ sender: Any) {
        txtDestination.resignFirstResponder()
        textType = TextType.destination.rawValue
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        //        filter.type = .address
        let countryCode = Locale.current.regionCode
        //        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
        //            print(countryCode)
        //        }
        
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
}


extension HomeVC : RideCancelDelegate {
    
    func cancelRide() {
        print("cancel Rideeee")
        paymentSuccess()
        self.vwTopDirection?.isHidden = true
        self.mapView.isMyLocationEnabled = true
        gameTimer?.invalidate()
    }
    
    
}

extension HomeVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharactersIn")
        return true
    }
    
}



extension HomeVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // print(place)
        let arrrayDestination = NSMutableArray()
        if textType == TextType.source.rawValue {
            txtSource.text = place.formattedAddress
            self.sourceCoordinates = place.coordinate
            //            print("place.coordinate ",place.coordinate)
            //            print("self.sourceCoordinates ",self.sourceCoordinates)
            if sourceCoordinates != nil && destinationCoordinates != nil {
                
                // MARK:- Draw Polyline
                
                fetchRoute(from: self.sourceCoordinates!, to: self.destinationCoordinates!)
                if objSocketResponse.count > 0 {
                    // SocketIOManager.sharedInstance.sendServiceData(userId: "\(/objLoginResponse?.user?.id)", userLat: "\(/locationManager.location?.coordinate.latitude)", userLong: "\(/locationManager.location?.coordinate.longitude)",address: /txtSource.text,destinations: arrrayDestination)
                    let objDestination = setDestinationAddress(address: txtDestination.text ?? "", lat: /destinationCoordinates?.latitude, long: /destinationCoordinates?.longitude)
                    arrrayDestination.add(objDestination)

                    SocketIOManager.sharedInstance.sendServiceData(userId: "\(/objLoginResponse?.user?.id)", userLat: /sourceCoordinates?.latitude, userLong: /sourceCoordinates?.longitude,address: /txtSource.text, destinations: arrrayDestination)
//                    destinationArray.insert(objDestination, at: 0)
                    //print("self.sourceCoordinatessssss ",self.sourceCoordinates)
                    
                    self.showFetchRidePopup()
                } else {
                    self.view.makeToast(AlertMessage.noDriverFound.localized, duration: 3.0, position: .bottom)
                    
                }
            }
            //let destination = self.setSourceAddress(address: /place.formattedAddress, lat: "\(/self.sourceCoordinates?.latitude)", long: "\(/self.sourceCoordinates?.longitude)")
            //self.destinationArray.insert(destination, at: 0)
            
        } else if textType == TextType.destination.rawValue  {
            txtDestination.text = place.formattedAddress
            self.destinationCoordinates = place.coordinate
            let destination = setDestinationAddress(address: "\(place.formattedAddress ?? "-")", lat: self.destinationCoordinates?.latitude ?? .zero, long: self.destinationCoordinates?.longitude ?? .zero)

            if sourceCoordinates != nil && destinationCoordinates != nil {
                fetchRoute(from: self.sourceCoordinates!, to: self.destinationCoordinates!)
                print("objSocketResponse ",objSocketResponse)
                
                arrrayDestination.add(destination)
                if objSocketResponse.count > 0 {
                    SocketIOManager.sharedInstance.sendServiceData(userId: "\(self.objLoginResponse?.user?.id ?? 0)", userLat: /self.sourceCoordinates?.latitude, userLong: /sourceCoordinates?.longitude, address: /txtSource.text,destinations: arrrayDestination)
                    self.showFetchRidePopup()
                }
                else {
                    self.view.makeToast(AlertMessage.noDriverFound.localized, duration: 3.0, position: .bottom)
                }
                
            }
            self.destinationArray = [destination]
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showCarlist() {
        
        //        UIView.animate(withDuration: 0.5,
        //                       delay: 0, usingSpringWithDamping: 1.0,
        //                       initialSpringVelocity: 1.0,
        //                       options: .overrideInheritedCurve, animations: {
        //
        //                        self.view?.addSubview(self.vwCarlist)
        //
        //                        self.vwCarlist.frame = CGRect(x: 0, y: self.view.frame.height - 300 , width: self.view.frame.width, height: 220)
        //
        //
        //                       }, completion: nil)
        
        //        self.vwFetchRide.removeFromSuperview()
        self.vwFetchRide.isHidden = true
        self.vwCarlist.isHidden = false
        
        vwCarlist.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 280)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [self] in
            let height = self.view.frame.height - (vwBottomOnlineHeight.constant + bottomLayoutGuide.length + 220)
            print("height", height)
            vwCarlist.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: 220)
            //            vwCarlist.frame = CGRect(x: 0, y: self.view.frame.height - 340, width: self.view.frame.width, height: 220)
        }) { finished in
            
        }
        self.view.addSubview(vwCarlist)
        
    }
    
    
}

extension HomeVC : CarSelected {
    func selectCar(serviceId: Int) {
        
        SocketIOManager.sharedInstance.findRide(userId: "\(/objLoginResponse?.user?.id)", userLat: /locationManager.location?.coordinate.latitude, userLong: /locationManager.location?.coordinate.longitude, serviceID: serviceId,destination: [], address: "Sunam")
    }
    
    
}


//MARK:- Car List Table View

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwStops {
            return arryStops.count + 1
        }else {
            return carListArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CarListTbCell?
        if tableView == tblVwStops {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellAddStop", for: indexPath) as? CarListTbCell
            cell?.txtSource.tag = indexPath.row
            cell?.txtSource.placeholder = "Source One"
            cell?.txtSource.isUserInteractionEnabled = false
            return cell ?? UITableViewCell()
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "CarListTbCell", for: indexPath) as? CarListTbCell
            let imgUrl = carListArray[indexPath.row].image
            //print("carListArray ",carListArray)
            cell?.imgVw.sd_setImage(with: URL(string: /imgUrl), placeholderImage: #imageLiteral(resourceName: "car_XS"))
            cell?.lblCarName.text =  /carListArray[indexPath.row].title
            let tipText: String = String(format: "%.2f", /carListArray[indexPath.row].amount)
            cell?.lblPrice.text = "$ \(tipText)"
            let minutes = carListArray[indexPath.row].minutes ?? .zero
            let timeStr: String = String(format: "%.2f", minutes)
            //            cell?.lblAwayTime.text = "\(timeStr)" + " minutes away"
            cell?.lblAwayTime.text = "\(minutes.minutesToTime())" + " minutes away"
            cell?.lblNumberPerson.text = "\(/carListArray[indexPath.row].seats)"
            
            if selectedRow == /carListArray[indexPath.row].id {
                cell?.vwChild.layer.borderColor = UIColor.appColor.cgColor
                cell?.vwChild.layer.borderWidth = 1
            }
            else {
                cell?.vwChild.layer.borderColor = UIColor.clear.cgColor
                cell?.vwChild.layer.borderWidth = 0
            }
            return cell ?? UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwStops {
            //            txtSource.resignFirstResponder()
            //            textType = TextType.source.rawValue
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }else {
            selectedRow = /carListArray[indexPath.row].id
            btnSelect.layer.borderColor = UIColor.appColor.cgColor
            btnSelect.setTitleColor(UIColor.appColor, for: .normal)
            btnSelect.isUserInteractionEnabled = true
            tblCarList.reloadData()
        }
    }
    
    func setSourceAddress(address: String, lat: String, long: String) -> [String:Any] {
        let sourceParam = [
            "address" : address,
            "lat" : String(format: "%.7f", lat),
            "lng" : String(format: "%.7f", long)
        ] as [String : Any]
        
        return sourceParam
    }
    
    func setDestinationAddress(address: String, lat: Double, long: Double) -> [String:Any] {
        let destinationParam = [
            "address" : address,
            "lat" : String(format: "%.7f", lat),
            "lng" : String(format: "%.7f", long)
        ] as [String : Any]
        
        return destinationParam
    }
    
    
    func dictToData(dictionaryExample:NSDictionary){
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionaryExample, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print("jsonString ",jsonString)
            let data = jsonString.data(using: .utf8)!
            let driverData = try! JSONDecoder().decode(Driver.self, from: data)
            //  print("successDataaaa ",driverData)
            self.objDriver = driverData
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
    }
    
}

extension HomeVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Tapped notification message: \(response.notification.request.content.userInfo)")
        if response.notification.request.identifier == "messageReceived" {
            let dictionary = response.notification.request.content.userInfo;
            if let newMessage = dictionary.decodeTo(classType: ChatMessage.self).model {
                openChatting(with: newMessage)
            }
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
