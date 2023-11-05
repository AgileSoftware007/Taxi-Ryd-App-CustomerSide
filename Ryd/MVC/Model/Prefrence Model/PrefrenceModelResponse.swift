// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let savePreffrenceResponse = try? newJSONDecoder().decode(SavePreffrenceResponse.self, from: jsonData)

import Foundation

// MARK: - SavePreffrenceResponse
struct SavePreffrenceResponse: Codable {
    let status: Bool?
    let message: String?
    let user: User?
}
