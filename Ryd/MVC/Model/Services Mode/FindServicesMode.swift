// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let findServiceResponse = try? newJSONDecoder().decode(FindServiceResponse.self, from: jsonData)

import Foundation

// MARK: - FindServiceResponse
struct FindServiceResponse: Codable {
    let amount: Double?
    let distance,minutes: Double?
    let driverID, id: Int?
    let image: String?
    let seats: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case amount, distance
        case driverID = "driver_id"
        case id, image, minutes, seats, title
    }
}
