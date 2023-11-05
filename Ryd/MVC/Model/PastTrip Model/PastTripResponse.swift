
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pastTrip = try? newJSONDecoder().decode(PastTrip.self, from: jsonData)

import Foundation

// MARK: - PastTrip
struct PastTripResponse: Codable {
    let status: Bool?
    let trips: [Trip]?
}

// MARK: - Trip
struct Trip: Codable {
    let id, userID, serviceID, vehicleID, driverID: Int?
    let pickupAddress, toAddress, distance, duration: String?
    let customerTotal, driverTotal, status, created: String?
    let userFirstName, userLastName, userPhonenumber, driverFirstName: String?
    let driverLastName, driverPhonenumber, serviceTitle, vehicleNumber: String?
    let vehicleBrand, vehicleModel: String?
    let charges: Charges?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case serviceID = "service_id"
        case vehicleID = "vehicle_id"
        case driverID = "driver_id"
        case pickupAddress = "pickup_address"
        case toAddress = "to_address"
        case distance, duration
        case customerTotal = "customer_total"
        case driverTotal = "driver_total"
        case status, created
        case userFirstName = "user_first_name"
        case userLastName = "user_last_name"
        case userPhonenumber = "user_phonenumber"
        case driverFirstName = "driver_first_name"
        case driverLastName = "driver_last_name"
        case driverPhonenumber = "driver_phonenumber"
        case serviceTitle = "service_title"
        case vehicleNumber = "vehicle_number"
        case vehicleBrand = "vehicle_brand"
        case vehicleModel = "vehicle_model"
        case charges
    }
}

// MARK: - Charges
struct Charges: Codable {
    let waitingTime: String?
    let driverFreeWaitTime, freeWaitTime: String?
    let timeBeforeTripStarts: Int?
    let distanceBeforeTripStarts: Double?
    let bookingFee, pickupFee: String?
    let perMile, perMinutes, waitTime: Double?
    let surgeCharge, atlantaFee, emFee, etFee: String?
    let gaTax, tip: String?
    let totalAmount: Double?
}
