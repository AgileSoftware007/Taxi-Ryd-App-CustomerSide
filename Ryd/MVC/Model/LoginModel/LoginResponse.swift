
import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Bool?
    let message: String?
    var user: User?
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let status, isVerified, driver, countryCode, flag, airportTrips: Int?
    let firstName, lastName, phonenumber: String?
    let dob, address: String?
    let image: Image?
    let bio: String?
    let lastLogin, gender, email: String?
    let verifiedAt: String?
    let otp, deletedAt, createdBy: String?
    let created, modified: String?
    let documents: [Documents]?
    var cards: [Card]?
    let addreses: Address?
    let access: Access?
    let femaleDriverOnly, spanishSpeakingOnly, wheelChair: String?
    let contactByEmail: String?
    let languages: [Languages]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case phonenumber, dob, address, image, bio
        case lastLogin = "last_login"
        case gender, email, status
        case isVerified = "is_verified"
        case verifiedAt = "verified_at"
        case driver, otp
        case deletedAt = "deleted_at"
        case createdBy = "created_by"
        case femaleDriverOnly = "female_driver_only"
        case spanishSpeakingOnly = "spanish_speaking_only"
        case flag
        case airportTrips = "airport_trips"
        case contactByEmail = "contact_by_email"
        case wheelChair = "wheel_chair"
        case created, modified, documents, cards, addreses, access,languages
    }
}

// MARK: - Access
struct Access: Codable {
    let id: Int?
    let token: String?
}

// MARK: - Document
struct Documents: Codable {
    let id, userID, verified: Int?
    let title, file, slug: String?
    let expiryDate, created, modified: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, slug, file, verified
        case expiryDate = "expiry_date"
        case created, modified
    }
}

enum Slug: String, Codable {
    case drivingLicenseBack = "driving-license-back"
    case drivingLicenseFront = "driving-license-front"
    case insuranceProof = "insurance-proof"
    case vehicleRegistration = "vehicle-registration"
}

// MARK: - Image
struct Image: Codable {
    let original, large, medium, small: String?
}

// MARK: - Languages
struct Languages: Codable {
    let id: Int?
    let title, code: String?
    let pivot: Pivot?
}

struct Pivot: Codable {
    let userID, languageID: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case languageID = "language_id"
    }
}
