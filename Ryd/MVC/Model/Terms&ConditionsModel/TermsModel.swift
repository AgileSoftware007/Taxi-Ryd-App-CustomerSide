// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let termsAndConditionsResponse = try? newJSONDecoder().decode(TermsAndConditionsResponse.self, from: jsonData)

import Foundation

// MARK: - TermsAndConditionsResponse
struct TermsConditionsResponse: Codable {
    let status: Bool?
    let message: String?
    let page: Page?
}

// MARK: - Page
struct Page: Codable {
    let id: Int?
    let title, pageDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case pageDescription = "description"
    }
}


