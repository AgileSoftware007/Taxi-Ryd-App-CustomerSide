import UIKit
import SocketIO
import CoreLocation

var socketUserLat: Double?
var socketUserLong: Double?
var socketUserId: String?

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    var objSocketModel = [SocketModel]()
    
//	var manager = SocketManager(socketURL: URL(string: "http://167.99.119.160:7000")!, config: [
    var manager = SocketManager(socketURL: URL(string: "http://159.89.191.168:3000")!, config: [
        .log(true),
        .compress,
        .connectParams(["user_id":/socketUserId,
                        "lat":String(format: "%.7f", /socketUserLat),
                        "lng":String(format: "%.7f", /socketUserLong),
                        "role":"customer",
                        "EIO":"4"])])
    
    var socket : SocketIOClient?
    
    
    override init(){
        super.init()
        socket = manager.defaultSocket
    }
    
    
    func emitCall(userId: String, userLat: Double, userLong: Double) {
        
        // Sunam Home
        self.socket?.emit("isonline", ["id":"\(userId)","lat": String(format: "%.7f", userLat),"lng": String(format: "%.7f", userLong)])
        
        
        //        self.socket.emitWithAck("isonline", ["id":"53","lat":"37.33233141","lng":"-122.0312186"]).timingOut(after: 0.5) { (response) in
        //            print(response)
        //
        //        }
        
    }
    
    func establishConnection (){
        self.socket?.connect()
    }
    
    func closeConnection(){
        self.socket?.disconnect()
    }
    
    
    func getDriverList() {
        socket?.on("isonline") { (dataArray, ack) in
            print("DRIVER LIST dataArray ",dataArray)
            if dataArray.count > 0 {
                
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .showDriverCar,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    //MARK:- Find Cars Event
    
    func findServices() {
        socket?.on("find-services") { (dataArray, ack) in
            print("find-services dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .carLists,object: nil,userInfo: response)
            }
            else {
                print("FInd SErvice Else")
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    //MARK:- Find Cars Emit
    func sendServiceData(userId: String, userLat: Double, userLong: Double, address: String,destinations: NSMutableArray){
        self.socket?.emit("find-services", ["id":"\(userId)","lat": String(format: "%.7f", userLat),"lng":String(format: "%.7f", userLong), "address":"\(address)","destinations":destinations])
        
    }
    
    //MARK:- Find Ride Emit
    func findRide(userId: String, userLat: Double, userLong: Double, serviceID: Int, destination:NSMutableArray,address:String){
        self.socket?.emit("find-ryd", ["id":"\(userId)","lat": String(format: "%.7f", userLat), "lng": String(format: "%.7f", userLong), "service_id":serviceID, "destinations":destination, "address":address])
    }
    
    //MARK:- Find Ride Event
    func findRides() {
        socket?.on("find-ryd") { (dataArray, ack) in
            print("find-ryd dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .showndRideCars,object: nil,userInfo: response)
                
            }
            else {
                print("FInd Ryd Else")
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    func getOfflineDriver(){
        socket?.on("isoffline") { (dataArray, ack) in
            print("dataArray offline ",dataArray.count)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .removeCar,object: nil,userInfo: response)
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Accept Ride Event
    func acceptRide() {
        socket?.on("accept-ryd") { (dataArray, ack) in
            print("accept-ryd dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .acceptRide,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Decline Ride Event
    func declineRide() {
        socket?.on("decline-ryd") { (dataArray, ack) in
            print("Decline-ryd dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .declineRide,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Driver OutSide Event
    func driverOutSide() {
        socket?.on("driver-outside") { (dataArray, ack) in
            print("driver-outside dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .outSideDriver,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Driver Outside Emit
    func driverOutSideEmit(tripId: String, driverId: String, customerId: String){
        self.socket?.emit("accept-ryd", ["trip_id":"\(tripId)","driver_id":"\(driverId)","customer_id":"\(customerId)"])
        
    }
    
    
    //    //MARK:- Cancel Trip Event
    //    func cancelRyd() {
    //        socket?.on("cancel-ryd") { (dataArray, ack) in
    //            print("cancel-ryd dataArray ",dataArray)
    //            if dataArray.count > 0 {
    //                let response = ["userInfo": dataArray]
    //              NotificationCenter.default.post(name: .cancelRyd,object: nil,userInfo: response)
    //
    //            }
    //            else {
    //                let window = UIApplication.shared.windows.first
    //                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
    //            }
    //        }
    //    }
    //
    //
    //    //MARK:- Cancel Ryd Emit
    //    func cancelRyd(tripId: Int){
    //        self.socket?.emit("cancel-ryd", ["trip_id":"\(tripId)"])
    //
    //    }
    
    //MARK:- Update Trip Event
    func updateLocation() {
        socket?.on("update-location") { (dataArray, ack) in
            print("update-location dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
//                NotificationCenter.default.post(name: .cancelRyd,object: nil,userInfo: response)
                NotificationCenter.default.post(name: .updateDriverLocation,object: nil,userInfo: response)

            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Update Location  Emit
    func updateLocationEmit(userID: String, driverId: String, type: String, lat:Double, lng: Double){
        self.socket?.emit("update-location", ["user_id":"\(userID)","driver_id":"\(driverId)", "type":"customer", "lat":String(format: "%.7f", lat),"lng":String(format: "%.7f", lng)])
        
    }
    
    
    //MARK:- Cancel Trip Event
    func cancelRyd2() {
        socket?.on("cancel-ryd") { (dataArray, ack) in
            print("cancel-ryd dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .cancelRyd,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Cancel Ryd Emit
    func cancelRyd2(tripId: String, cancelBy: String, lat: Double, lng: Double, location: String){
        self.socket?.emit("cancel-ryd", ["trip_id":"\(tripId)","cancel_by":"\(cancelBy)","lat":String(format: "%.7f", lat), "lng":String(format: "%.7f", lng), "location":"\(location)"])
        
    }
    
    //MARK:- Start Trip / Destination Event
    func startDestination() {
        socket?.on("start-destination") { (dataArray, ack) in
            print("start-destination  dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .startDestination,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Start Trip / Destination Emit
    func startDestinationEmit(tripId: String,destinationId: String){
        self.socket?.emit("start-destination", ["trip_id":"\(tripId)","destination_id":"\(destinationId)"])
        
    }
    
    //MARK:- End Destination Event
    func endDestination() {
        socket?.on("end-destination") { (dataArray, ack) in
            print("end-destination  dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .endDestination,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- End Destination Emit
    func endDestinationEmit(tripId: String,destinationId: String){
        self.socket?.emit("end-destination", ["trip_id":"\(tripId)","destination_id":"\(destinationId)"])
        
    }
    
    //MARK:- End Trip Event
    func endTrip() {
        socket?.on("end-trip") { (dataArray, ack) in
            print("end-trip  dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .endTrip,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- End Trip Emit
    func endTripEmit(tripId: String){
        self.socket?.emit("end-trip", ["trip_id":"\(tripId)"])
        
    }
    
    
    //MARK:- Driver Start Waiting Time Event
    func startWaitingTime() {
        socket?.on("start-waiting") { (dataArray, ack) in
            print("start-waiting  dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .startWaiting,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Driver Start Waiting Time Emit
    func startWaitingTimeEmit(tripId: String){
        self.socket?.emit("start-waiting", ["trip_id":"\(tripId)"])
        
    }
    
    
    //MARK:- Driver End Waiting Time Event
    func endWaitingTime() {
        socket?.on("end-waiting") { (dataArray, ack) in
            print("end-waiting  dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray]
                NotificationCenter.default.post(name: .endWaiting,object: nil,userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    
    //MARK:- Driver End Waiting Time Emit
    func endWaitingTimeEmit(tripId: String,waitingId: String, seconds: String){
        self.socket?.emit("end-waiting", ["trip_id":"\(tripId)","waiting_id":"\(waitingId)","seconds":"\(seconds)"])
        
    }
    
    //MARK:- Get Message List Event
    func getMessage() {
        socket?.on("message") { (dataArray, ack) in
            print("messages  dataArray ",dataArray)
            if dataArray.count > 0 {
                let response = ["userInfo": dataArray.first]
                NotificationCenter.default.post(name: .messageReceived, object: nil, userInfo: response)
                
            }
            else {
                let window = UIApplication.shared.windows.first
                window?.rootViewController?.view.makeToast(AlertMessage.noDataFound.localized, duration: 3.0, position: .bottom)
            }
        }
    }
    
    func sendMessage(message: ChatMessage, completion: (() -> ())? = nil) {
        self.socket?.emit("message", message.toDictionary(), completion: completion)
    }
    
    
}
