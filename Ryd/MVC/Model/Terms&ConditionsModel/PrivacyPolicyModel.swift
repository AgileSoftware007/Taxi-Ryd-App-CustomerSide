// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let privacyPolicyResponse = try? newJSONDecoder().decode(PrivacyPolicyResponse.self, from: jsonData)

import Foundation

// MARK: - PrivacyPolicyResponse
struct PrivacyPolicyResponse: Codable {
    let status: Bool?
    let page: Pages?
}

// MARK: - Page
struct Pages: Codable {
    let id: Int?
    let title, pageDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case pageDescription = "description"
    }
}
