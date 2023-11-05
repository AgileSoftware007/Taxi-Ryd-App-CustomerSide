//
//  ViewController.swift
//  TimeLeft Shape Sample
//
//  Created by lsd on 5/17/15.
//  Copyright (c) 2015 Leonardo Savio Dabus. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import CoreLocation
import SwiftyJSON

extension HomeVC {
    
    func drawBgShape() {
        self.bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: 30 , y: 30), radius:
                                                25, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.appColor.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 3
        vwProgress.layer.addSublayer(bgShapeLayer)
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: 30 , y: 30), radius:
                                                25, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.white.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 3
        vwProgress.layer.addSublayer(timeLeftShapeLayer)
    }
    
    
}
extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

//MARKS: Google Map Delegates
extension HomeVC {
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("User's Current Latitude => ",/manager.location?.coordinate.latitude)
        print("User's Current Longitude => ",/manager.location?.coordinate.longitude)
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        self.getAddress(lat: /self.locationManager.location?.coordinate.latitude, lng: /self.locationManager.location?.coordinate.longitude) { (address) in
            var addStr : String?
            addStr = address[0] as? String
            self.txtSource.text = addStr
        }
        
        self.mapView.camera = camera
                
       self.locationManager.stopUpdatingLocation()
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error::: \(error)")
        locationManager.stopUpdatingLocation()
        let alert = UIAlertController(title: "Settings", message: "Allow location from settings", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "TextMessages().callAlertTitle", style: .default, handler: { action in
            switch action.style{
            case .default:
                //UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                UIApplication.shared.canOpenURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            case .cancel: print("cancel")
            case .destructive: print("destructive")
                
            }
        }))
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, sourceIcon: UIImage? = nil, destinationIcon: UIImage? = nil) {
        let origin = "\(source.latitude),\(source.longitude)"
        let destinationn = "\(destination.latitude),\(destination.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destinationn)&mode=driving&key=\(/appdelegate?.googleMapServiceKey)"

        let url = URL(string: urlString)
       // print(url)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    
                    let loginResponse = try JSONDecoder().decode(RouteModel.self, from: /data)
                    self.objRoute = loginResponse
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
//                    print("json RESPONSE ",json)
                    DispatchQueue.main.async {
                        for route in routes {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            polyline.strokeColor = UIColor.appColor
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            self.mapView.clear()
                            self.mapView.mapType = .normal
                            polyline.map = self.mapView
                            
                            
                        }
                        
                        let sourceMarker = self.makeSourceMarker(location: source, markerIcon: sourceIcon)
                        let destinationMarker = self.makeDestinationMarker(location: destination, markerIcon: destinationIcon)
//                        self.showCarlist()
                    }
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }
    
    @discardableResult
    func makeSourceMarker(location: CLLocationCoordinate2D, markerIcon: UIImage? = nil) -> GMSMarker {
        
        let marker: GMSMarker = GMSMarker() // Allocating Marker
        
       // marker.title = "Source" // Setting title
       // marker.snippet = "Source Sub Title" // Setting sub title
        marker.icon = markerIcon ?? UIImage(named: "") // Marker icon
        marker.appearAnimation = .pop // Appearing animation. default
        marker.position = location // CLLocationCoordinate2D
        
        DispatchQueue.main.async { // Setting marker on mapview in main thread.
            marker.map = self.mapView // Setting marker on Mapview
        }
        return marker
    }
    
    func makeDestinationMarker(location: CLLocationCoordinate2D, markerIcon: UIImage? = nil){
        
        let marker: GMSMarker = GMSMarker() // Allocating Marker
        
       // marker.title = "Destination" // Setting title
       // marker.snippet = "Destination Sub title" // Setting sub title
        marker.icon = markerIcon ?? UIImage(named: "")
        marker.appearAnimation = .pop // Appearing animation. default
        marker.position = location // CLLocationCoordinate2D
        
        DispatchQueue.main.async { // Setting marker on mapview in main thread.
            marker.map = self.mapView // Setting marker on Mapview
        }
    }
    
    
    func openNavigationMap(lat: Double, long: Double)  {
            let latitude = lat
            let longitude = long
    //        let urlString = "comgooglemaps-x-callback://?saddr=&daddr=\(cordinate.latitude),\(cordinate.longitude)&directionsmode=driving"
            let appDomen: String = "comgooglemaps://"
            let browserDomen: String = "https://www.google.co.in/maps/dir/"
            let directionBody: String = "?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"
    
            // Make route with google maps application
            if let appUrl = URL(string: appDomen), UIApplication.shared.canOpenURL(appUrl) {
                guard let appFullPathUrl = URL(string: appDomen + directionBody) else { return }
                UIApplication.shared.open(appFullPathUrl, options: [:]) { (response) in
                    print("OPEN GOOGLE MAP RESPONSE ",response)
                }
                //UIApplication.shared.canOpenURL(appFullPathUrl)
                // If user don't have an application make route in browser
            } else if let browserUrl = URL(string: browserDomen), UIApplication.shared.canOpenURL(browserUrl) {
                guard let browserFullPathUrl = URL(string: browserDomen + directionBody) else { return }
                UIApplication.shared.openURL(browserFullPathUrl)
            }
        }
    
        
    @objc func showDriverCars(){
        
       // print(self.objSocketResponse)
        self.mapView.clear()
        for obj in self.objSocketResponse {
            let latitude = obj.lat?.toDouble() ?? .zero
            let longitude = obj.lng?.toDouble() ?? .zero
            
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
//            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(/Double(obj.lat ?? "0")) ?? 0, longitude: CLLocationDegrees(/obj.lng) ?? 0)
            print("driver location:", location)
            let marker: GMSMarker = GMSMarker() // Allocating Marker
            
           // marker.title = "Destination" // Setting title
            //marker.snippet = "Destination Sub title" // Setting sub title
            // Keep Rotation Short
            
            marker.icon = #imageLiteral(resourceName: "Ic_DriverCar") // Marker icon
            marker.appearAnimation = .pop // Appearing animation. default
            marker.position = location // CLLocationCoordinate2D
            marker.userData = obj.id
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            marker.rotation = .ulpOfOne
            CATransaction.commit()
            
            DispatchQueue.main.async { // Setting marker on mapview in main thread.
                marker.map = self.mapView // Setting marker on Mapview
            }
        }
    }
}


extension HomeVC {
    func getAddress(lat :CLLocationDegrees, lng: CLLocationDegrees,handler: @escaping (NSMutableArray) -> Void) {
        var address: String = ""
        let addressArray : NSMutableArray = []
        let geoCoder = CLGeocoder()
        let selectedLat = lat///self.sourceCoordinates?.latitude
        let selectedLon = lng///self.sourceCoordinates?.longitude
        let location = CLLocation(latitude: selectedLat, longitude: selectedLon)
        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            // Street address
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                address += street + ", "
            }
            
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                address += zip + ", "
            }
            
            // Country
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                address += country
            }
            addressArray.add(address)
            addressArray.add(/placeMark?.location?.coordinate.latitude)
            addressArray.add(/placeMark?.location?.coordinate.longitude)
            print("addressArray ",addressArray)
            handler(addressArray)
        })
    }
    
    
}


extension String
{
    /// EZSE: Converts String to Double
    public func toDouble() -> Double?
    {
       if let num = NumberFormatter().number(from: self) {
                return num.doubleValue
            } else {
                return nil
            }
     }
}
