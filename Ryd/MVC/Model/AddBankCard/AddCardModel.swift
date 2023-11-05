// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addCardResponse = try? newJSONDecoder().decode(AddCardResponse.self, from: jsonData)

import Foundation

// MARK: - AddCardResponse
struct AddCardResponse: Codable {
    let status: Bool?
    let message: String?
    let card: Card?
}

// MARK: - Card
struct Card: Codable {
    let cardName, cardNumber, cardType: String?
    let expiryDate, billingZip, created, modified: String?
    let id, userID: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case cardName = "card_name"
        case cardNumber = "card_number"
        case cardType = "card_type"
        case expiryDate = "expiry_date"
        case billingZip = "billing_zip"
        case created, modified, id
    }
}
