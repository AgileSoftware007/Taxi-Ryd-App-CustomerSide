// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getHelpResponse = try? newJSONDecoder().decode(GetHelpResponse.self, from: jsonData)

import Foundation

// MARK: - GetHelpResponse
struct GetHelpCategoriesResponse: Codable {
    let status: Bool?
    let categories: [Category]?
}

// MARK: - Category
struct Category: Codable {
    let id, createdBy: Int?
    let title, created, modified: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case createdBy = "created_by"
        case created, modified
    }
}


// MARK: - SubmitHelpResponse
struct SubmitHelpResponse: Codable {
    let status: Bool?
    let message: String?
}
