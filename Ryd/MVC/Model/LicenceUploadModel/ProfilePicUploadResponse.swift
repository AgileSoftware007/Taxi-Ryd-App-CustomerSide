// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profilePictureUploadResponse = try? newJSONDecoder().decode(ProfilePictureUploadResponse.self, from: jsonData)

import Foundation

// MARK: - ProfilePictureUploadResponse
struct ProfilePictureUploadResponse: Codable {
    let status: Bool?
    let message: String?
    let user: User?
}

// MARK: - User
//struct Userss: Codable {
//    let id: Int?
//    let firstName, lastName, countryCode, phonenumber: String?
//    let dob: String?
//    let address: String?
//    let image: Images?
//    let bio: String?
//    let lastLogin, gender, email, status: String?
//    let verifiedAt: String?
//    let driver: String?
//    let otp, deletedAt, createdBy: String?
//    let created, modified: String?
//    let access: Accesss?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case countryCode = "country_code"
//        case phonenumber, dob, address, image, bio
//        case lastLogin = "last_login"
//        case gender, email, status
//        case verifiedAt = "verified_at"
//        case driver, otp
//        case deletedAt = "deleted_at"
//        case createdBy = "created_by"
//        case created, modified, access
//    }
//}

//// MARK: - Access
//struct Accesss: Codable {
//    let id: Int?
//    let token: String?
//}
//
//// MARK: - Image
//struct Image: Codable {
//    let original, large, medium, small: String?
//}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
