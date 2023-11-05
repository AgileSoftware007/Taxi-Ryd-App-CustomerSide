// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addressResponse = try? newJSONDecoder().decode(AddressResponse.self, from: jsonData)

import Foundation

// MARK: - AddressResponse
struct AddressResponse: Codable {
    let status: Bool?
    let message: String?
    let address: Address?
    let user : User?
}

// MARK: - Address
struct Address: Codable {
    let id, userID: Int?
    let mailingAddress, addressLine, city: String?
    let state, zip, created, modified: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case mailingAddress = "mailing_address"
        case addressLine = "address_line"
        case city, state, zip, created, modified, id
    }
}
