// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let licenceFrontUploadResponse = try? newJSONDecoder().decode(LicenceFrontUploadResponse.self, from: jsonData)

import Foundation

// MARK: - LicenceFrontUploadResponse
struct LicenceFrontUploadResponse: Codable {
    let status: Bool?
    let message: String?
    let document: Document?
}

// MARK: - Document
struct Document: Codable {
    let id, userID: Int?
    let title, slug, file: String?
    let created, modified: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case title, slug, file, created, modified, id
    }
}
