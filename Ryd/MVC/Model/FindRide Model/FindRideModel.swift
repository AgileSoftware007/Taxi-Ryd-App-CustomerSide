//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let findRideResponse = try? newJSONDecoder().decode(FindRideResponse.self, from: jsonData)
//
//import Foundation
//
//// MARK: - FindRideResponse
//struct FindRideResponse: Codable {
////    let status: Bool?
//    let driver: Driver?
//    let destinations: [Destinations]?
//}
//
//// MARK: - Driver
//struct Driver: Codable {
//    let id: Int?
//    let brandID, modelID, colorID: String?
//    let vehicleImage: VehicleImage?
//    let seats, serviceID, serviceTitle, driverID: String?
//    let driverFirstName, driverLastName: String?
//    let driverImage: DriverImage?
//    let distance: Double?
//    let minutes, amount: String?
//    let vehicleID: Int?
//    let vehicleBrand, vehicleModel, vehicleColor: String?
//    let tripID: Int?
//    let fromAddress, fromAddressLat, fromAddressLng, pickupAddress: String?
//    let pickupAddressLat, pickupAddressLng: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case brandID = "brand_id"
//        case modelID = "model_id"
//        case colorID = "color_id"
//        case vehicleImage = "vehicle_image"
//        case seats
//        case serviceID = "service_id"
//        case serviceTitle = "service_title"
//        case driverID = "driver_id"
//        case driverFirstName = "driver_first_name"
//        case driverLastName = "driver_last_name"
//        case driverImage = "driver_image"
//        case distance, minutes, amount
//        case vehicleID = "vehicle_id"
//        case vehicleBrand = "vehicle_brand"
//        case vehicleModel = "vehicle_model"
//        case vehicleColor = "vehicle_color"
//        case tripID = "trip_id"
//        case fromAddress = "from_address"
//        case fromAddressLat = "from_address_lat"
//        case fromAddressLng = "from_address_lng"
//        case pickupAddress = "pickup_address"
//        case pickupAddressLat = "pickup_address_lat"
//        case pickupAddressLng = "pickup_address_lng"
//    }
//}
//
//// MARK: - Image
//struct VehicleImage: Codable {
//    let original, large, medium, small: String?
//}
//
//struct Destinations: Codable {
//    let address, created, end_time, lat,lng,modified, start_time,small: String?
//    let id,completed,trip_id : Int?
//}
//
struct DriverImage: Codable {
    let original, large, medium, small: String?
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

//import Foundation
//
//// MARK: - Welcome
//struct FindRideResponse: Codable {
//    let status: Bool
//    let driver: Driver
//}
//
//// MARK: - Driver
//struct Driver: Codable {
//    let id: Int
//    let brandID, modelID, colorID: String
//    let vehicleImage: Image
//    let seats, serviceID, serviceTitle, driverID: String
//    let driverFirstName, driverLastName: String
//    let driverImage: Image
//    let distance: Double
//    let minutes, amount: String
//    let vehicleID: Int
//    let vehicleBrand, vehicleModel, vehicleColor: String
//    let tripID: Int
//    let fromAddress, fromAddressLat, fromAddressLng, pickupAddress: String
//    let pickupAddressLat, pickupAddressLng: String
//    let destinations: [Destination]
//    let customer: Customer
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case brandID = "brand_id"
//        case modelID = "model_id"
//        case colorID = "color_id"
//        case vehicleImage = "vehicle_image"
//        case seats
//        case serviceID = "service_id"
//        case serviceTitle = "service_title"
//        case driverID = "driver_id"
//        case driverFirstName = "driver_first_name"
//        case driverLastName = "driver_last_name"
//        case driverImage = "driver_image"
//        case distance, minutes, amount
//        case vehicleID = "vehicle_id"
//        case vehicleBrand = "vehicle_brand"
//        case vehicleModel = "vehicle_model"
//        case vehicleColor = "vehicle_color"
//        case tripID = "trip_id"
//        case fromAddress = "from_address"
//        case fromAddressLat = "from_address_lat"
//        case fromAddressLng = "from_address_lng"
//        case pickupAddress = "pickup_address"
//        case pickupAddressLat = "pickup_address_lat"
//        case pickupAddressLng = "pickup_address_lng"
//        case destinations, customer
//    }
//}
//
//// MARK: - Customer
//struct Customer: Codable {
//    let id: Int
//    let firstName, lastName: String
//    let image: String?
//    let gender, femaleDriverOnly, spanishSpeakingOnly: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case image, gender
//        case femaleDriverOnly = "female_driver_only"
//        case spanishSpeakingOnly = "spanish_speaking_only"
//    }
//}
//
//// MARK: - Destination
//struct Destination: Codable {
//    let id: Int
//    let tripID, address, lat, lng: String
//    let startTime, endTime: String?
//    let completed, created, modified: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case tripID = "trip_id"
//        case address, lat, lng
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case completed, created, modified
//    }
//}
//
// MARK: - Image
struct VehicleImage: Codable {
    let original, large, medium, small: String
}

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let status: Bool?
    let driver: Driver?
}

// MARK: - Driver
struct Driver: Codable {
    let id: Int?
    let brandID, modelID, colorID: Int?
    let vehicleImage: VehicleImage?
    let seats, serviceID, driverID: Int?
    let serviceTitle, driverFirstName, driverLastName: String?
    let driverImage: DriverImage?
    let distance,minutes : Double?
    let amount: Float?
    let vehicleID, tripID, rating: Int?
    let vehicleBrand, vehicleModel, vehicleColor: String?
    let fromAddress, fromAddressLat, fromAddressLng, pickupAddress: String?
    let pickupAddressLat, pickupAddressLng: String?
    let destinations: [Destinationn]?
    let customer: Customer?

    enum CodingKeys: String, CodingKey {
        case id
        case rating
        case brandID = "brand_id"
        case modelID = "model_id"
        case colorID = "color_id"
        case vehicleImage = "vehicle_image"
        case seats
        case serviceID = "service_id"
        case serviceTitle = "service_title"
        case driverID = "driver_id"
        case driverFirstName = "driver_first_name"
        case driverLastName = "driver_last_name"
        case driverImage = "driver_image"
        case distance, minutes, amount
        case vehicleID = "vehicle_id"
        case vehicleBrand = "vehicle_brand"
        case vehicleModel = "vehicle_model"
        case vehicleColor = "vehicle_color"
        case tripID = "trip_id"
        case fromAddress = "from_address"
        case fromAddressLat = "from_address_lat"
        case fromAddressLng = "from_address_lng"
        case pickupAddress = "pickup_address"
        case pickupAddressLat = "pickup_address_lat"
        case pickupAddressLng = "pickup_address_lng"
        case destinations, customer
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int?
    let firstName, lastName: String?
    let image: VehicleImage?
    let gender, femaleDriverOnly, spanishSpeakingOnly, rating: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case image, gender
        case femaleDriverOnly = "female_driver_only"
        case spanishSpeakingOnly = "spanish_speaking_only"
        case rating
    }
}

// MARK: - Destination
struct Destinationn: Codable {
    let id, tripID: Int?
    let address, lat, lng: String?
    let startTime, endTime: String?
    let completed, created, modified: String?

    enum CodingKeys: String, CodingKey {
        case id
        case tripID = "trip_id"
        case address, lat, lng
        case startTime = "start_time"
        case endTime = "end_time"
        case completed, created, modified
    }
}


