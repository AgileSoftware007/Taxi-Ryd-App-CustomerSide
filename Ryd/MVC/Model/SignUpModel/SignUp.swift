//
//  SignUp.swift
//  DriverApp
//
//  Created by Harsh on 16/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import Foundation

struct SignUpParams: Codable {
    let firstName, lastName, countryCode, phonenumber: String?
    let password, deviceID, deviceType, deviceName: String?
    let fcmToken: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case phonenumber, password
        case deviceID = "device_id"
        case deviceType = "device_type"
        case deviceName = "device_name"
        case fcmToken = "fcm_token"
    }
}


// MARK: - SignUp
struct SignUpResponse: Codable {
    let status: Bool?
    let message, token, otp: String?
}
