

import UIKit
enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{5,16}" // PhoneNo 10-14 Digits
    case acceptAll = ""
}

//MARK: -----> TextField Type
enum FieldType : String{
    case email = "Email"
    case password = "Password"
    case name = "Name"
    case exam = "Exam"
    case firstName = "First Name"
    case lastName = "Last Name"
    case phone = "Mobile Number"
    case confirmPassword = "Confirm Password"
    case city = "City"
    case loginPassword = "Password "
    case countryCode = "Country Code"
    case zipCode = "Zip Code"
    case address = "Address"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//MARK: -----> Status
enum Status : String {
    case empty = "Please enter "
    case allSpaces = "Enter the "
    case passwordFormat = "Your Password must contain one capital letter and one numeric and one special character"
    case valid
    case inValid = "Please enter a valid "
    case allZeros = "Please enter a Valid "
    case hasSpecialCharacter = " can only contain A-z, a-z characters only"
    case nameLength = " length should be in between 2 - 40 characters"
    case notANumber = " must be a number "
    case emptyCountrCode = "Enter country code "
    //case mobileNumberLength = " Mobile Number should be of atleast 6 - 15 number"
    case mobileNumberLength = " Mobile Number should be of atleast 10 digits"
    case pwd = "Password length should be between 6-15 characters"
    case pinCode = "Zip Code length should be 5 characters long"
    case zip = "Zip Code should not contain special characters"
    case address = "Address length should be of 2 to 60 characters"
    case exam = "Please Select Course type"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func message(type : FieldType) -> String? {
        switch self {
        case .hasSpecialCharacter: return type.localized + localized
        case .nameLength: return type.localized + localized
        case .valid: return nil
        case .passwordFormat : return rawValue
        case .emptyCountrCode: return localized
        case .pwd: return rawValue
        case .mobileNumberLength : return localized
        case .pinCode , .zip : return localized
        case .exam: return localized
        default: return localized + type.localized
        }
    }
}

