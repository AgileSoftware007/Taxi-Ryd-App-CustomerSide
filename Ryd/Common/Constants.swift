
import Foundation
import UIKit


let ScreenSize = UIScreen.main.bounds
let AppName = "com.prepladder.oneprep"
//let Version = "1"
let Platform = "ios"
let appId = 1

let apiAppName = "Ryd_DriverAPP"

let appdelegate = (UIApplication.shared.delegate as? AppDelegate)
@available(iOS 13.0, *)
//let sceneDelegate = (UIApplication.shared.delegate as? SceneDelegate)
let cornerRadius:CGFloat = 8.0
var CountryCode = 1
var appItuneLink = "https://apps.apple.com/us/app/id1529720146"

//let deviceUDUD =  UIDevice.current.identifierForVendor!.uuidString


let DEVICE_NAME =  UIDevice.current.name
let DEVICE_MODEL =  UIDevice.current.model
let DEVICE_SYSTEM_VERSION =  UIDevice.current.systemVersion
let DEVICE_MANUFACTURE_NAME =  UIDevice.current.systemName
let DEVICE_TYPE =  "ios"
let USER_TYPE =  "customer"
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString
var BARRERTOKEN = ""
var SIGNUP = "SignUp"
var LOGIN = "Login"
var FORGOT = "Forgot"
let UDManager = UserDefaults.standard

let slugDrivingFront = "driving-license-front"
let slugDrivingBack = "driving-license-back"
let slugInsurance = "insurance-proof"
let slugVehicleRegistration = "vehicle-registration"

//MARK: -----> Title Type
enum TitleType : String{
   
    case info = "Information"
    case delete = "Delete"
    case error  = "Error"
    case Sucess  = "success"
    case noInternet  = "Network error"
    case editProfile = "Edit profile"
    case updateProfile = "Update profile"
    case version = "Version "
    case ChooseOption = "Choose option"
    case emailRequiered = "Email requiered"
    case logOut = "Log out"
    case forgot = "Forgot"
    case termsAndConditions = "Terms and conditions"
    case settings = "Settings"
    case chooseCountry = "Choose country"
    case login = "Login"
    case update = "Update"
    case normalUpdate = "A new update is available. Do you want to update it now."
    case forceUpdate = "Your app seems to be outdated , you need to update your app."
    case quit = "Quit"
    case remove = "Remove"
    case alert = "Alert"
    case addImage = "Add image"
    case confirm = "Confirm"
    case logout = "Log out"
    case setting = "Setting"
    case ok = "Ok"
    case commingSoon = "This feature will be available soon"

    case nextVideo = " Next video will be live soon"
    case dashboardLatestBlog = "We are arriving soon. Please stay with us."

    case creditSecdonds = "You have exhausted all your credit seconds"
    case modules = "Modules"
    case module = "module"
    case success = "Success"
    case feedBackTitle = "Feedback"
    case loggedIn = "LoggedIn device"
    case CreditHours = "Credit hours"
    case sessionExpired = "Session expired"

    
    
   
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum LocalizedText : String{
     case  Bookmark = "Bookmark"
     case  Bookmarks = "Bookmarks"
     case  Edit = "EDIT"
     case  Done = "DONE"
     case  DeltedBookMark = "You have deleted all your bookmarks.Please add new one"
      case  bookMarkRemoved = "REMOVED FROM BOOKMARKS"
     case  noBookMark = "No bookmark"
     case  Downloading = "Downloading..."
     case  VideoDownloading = "Video downloading"
     case  PrepareDownloadingPause = "Downloading paused"
     case  Downloaded = "Downloaded"
     case  Paused = "Video Paused"
     case  Completed = "Completed"
     case  Premium = "Premium"
     case   ReadNotes = "Read books"
     case   Notes = "Books"
     case   Slides = "Slides"
     case  videoQueued = " Video queued"
     case  comingsoon = "coming soon"
     case  questions = "Questions"
     case   practiceBookmarked = "Practice bookmarked"
     case   practiceIncorrect = "Practice incorrect"
     case   freeVideos = "Free videos"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//MARK: -----> Alert Message
enum AlertMessage : String{
    
    case alert = "Alert!"
    case success = "Success"
    case warning = "Warning!"
    case downloadVideo = "Download video"
    case downloadVideoPause  = "Please pause running video before start other one."
    case logout  = "Are you sure you want to logout?"
    case logoutTitle  =  "Confirm logout"
    case mobileLimit  = "Mobile number should be of atleast 6 - 15 number"
    case enterEmailOrPhone = "Please enter name"
    case examType = "Please select course type"
    case emptyPassword = "Please enter password"
    case popUpAlert = " Thank you for joining! Please check your email and verify your email address.If you do not see an email, please check your spam folder."
    
    case videoScreenShot = "Please do not take screenshots of video slide.\n This will result in deactivation of your OnePrep account for 15 days."
    
//     case notesScreenShot = "Please do not take screenshots of videos.\n This will result in deactivation of your OnePrep account for 15 days."
    
    //Change Password
     case jailbrokeTitle = "Jailbroke iPhone"
     case JailbrokeMessage = "Apps are not allowed to run on jailbroke phones"
    
    case emptyCurrentPassword = "Please enter current password"
  
    case confirmPasswordNotMatch = "Confirm password not Match"
    case ok = "Okay"
    case areYouSureYouWantToLogout = "Are you sure you want to sign out?"
     case thisvideoNoLonger = "This video will no longer show Completed status, its progress will work as other videos."
    case enterEmailAddress = "Enter your email address"
    case enterEmail = "Please enter email address"
    case validEnterEmail = "Please enter valid email address"
    case enterDropLocation = "Please enter drop location"
    case loginAsFb = "You are currently logged in as facebook user"
    case loginAsGmail = "You are currently logged in as gmail user"
    case emailRequ
    
    case profileUpdated = "Profile updated successfully"
    case passwordChangedSuccess = "Password updated successfully"
    case delete = "Are you sure you want to delete it?"
    case selectPicture = "Please select a profile picture"
    case enterCorrectOtp = "Please enter the correct verification code"
    case maximumOtp = "You can enter the OTP incorrectly a maximum of 3 times.Please try again"
    
    
    case enterOtp = "Please enter OTP"
    case videos = "Videos"
    case allowLocation = "Please turn on location services in settings"
    case passwordMismatch = "Password and confirm Password must be same"
    case noInternet = "Please check your internet connection"
    case enterOldPassword = "Please enter old password"
    case enterNewPassword = "Please enter new password"
    case enterConfirmPassword = "Please enter confirm password"
    case matchConfirmAndNew = "New password and confirm password must be same"
    case loginSuccessfull = "Logged in successfully"
    case logoutSuccess = "Logged out successfully"
    case somethingWentWrong = "Something went wrong"
    case sessionExpired = "Your session has been expired. Please login again"
    case account = "Please select account type."
    case passwordSent = "Password has been sent on your registered email."
    case emptyMsg = "You cannot send an empty message."
    
    case emptyContent = "Post content can't be empty."
    case tagRequire = "Atleast one tag is required."
    case commentEmpty = "The comment field is required."
    case empty = "Search field is mendatory."
    case  camera = "Camera"
    case  gallery = "Gallery"
    case  video = "Video"
    case  pleaseChoose = "Please choose"
    case  noDeviceOnCamera = "No camera on this device"
    case cancel = "Cancel"
    case settingsUpdated = "Settings updated!"
    case signUp = "Please signUp!"
    case screenShotError = "Please do not take screenshots of Books.\n This will result in deactivation of your oneprep account for 15 days."
    case copyrightText = "These videos are a copyright of oneprep.\n Any attempt to record or distribute the videos will initiate a legal procedure without a prior warning"
    case otpResendMsg = "OTP sent sucessfully"
    case slideNotAvail = "Video slides are not available for this videos"
    
    
    case otheruserLogin = "Your account was logged in on another device. You need to login again to continue using the app"

    case feedBackMsg = "Thank you for your feedback"
    case loggedInMsg = "No logged in device"
    
    case feedBackMarkComplete = "Please enter your feedback"
    
    case ratingMarkComplete = "Please fill your rating"
    
    
    case statsQBMsg = "This is the total number of questions you have attempted. This includes MCQs, Practical questions, and Theory based questions."
    
    case statsIndicationMsg = "This is statsindication."
    case paperInfoBtnMsg = "Disclaimer: RTP's, MTP's and Past papers have been compiled from ICAI.org"
    
    
    case emptyPhoneNumber = "Phone number can't be blank."
    case invalidPhoneNumber = "Invalid phone number"
    case invalidEmail = "Invalid email address"
    case invalidPassword = "Password must be at least 8 characters long"
    case passwordNotMatch = "Password doesn't match"
    case emptyName = "User name can't be blank."
    case emptyLastName = "Last name can't be blank."
    case emptyEmail = "Email can't be blank."
    case emptyConfirmEmail = "Confirm email can't be blank."
    case confirmEmailNotMatch = "Email doesn't match"
    case emptyMaillingAddress = "Mailling address can't be blank."
    case emptyAddressLine = "Address line can't be blank."
    case emptyCity = "City name can't be blank."
    case emptyState = "State name can't be blank."
    case emptyZipCode = "Zip code can't be blank."
    case emptyGender = "Please select gender"
    case drivingLicenceFrontText = "Driver's license - front"
    case drivingLicenceBackText = "Driver's license - back"
    case insuranceText = "Proof of insurance"
    case vehicleRegistration = "Vehicle registration"
    case emptyOldPassword = "Old password can't be blank."
    case emptyNewPassword = "New password can't be blank."
    case emptyConfirmPassword = "Confirm password can't be blank."
    case emptyDrivingLicencefront = "Please attach driving licence."
    case emptyVehicleRegPicture = "Please attach vehicle registration."
    case emptyInsuranceProff = "Please attach insurance."
    case emptyFavorite = "Favorites text field can't be blank."
    case profilePendingReview = "Your profile is under verification."
    case deleteFavoriteLocation = "You deleted the location successfully"
    case emptyCardName = "Card name can't be blank."
    case emptyCardNumber = "Card number can't be blank."
    case emptyCardDate = "Card date can't be blank."
    case emptyCardCvv = "Card CVV can't be blank."
    case emptyCardZipCode = "Card zip code can't be blank."
    case emptyHelpMessage = "Message can't be blank."
    case noDataFound = "No data found."
    case noSelectCar = "Please select car type first."
    case noDriverFound = "No drivers nearby."
    case addPayment = "Please add credit/debit card to get rides."
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum CellsIdentifier {
    enum collectionViewCell: String {
        case a = ""
    }
    
    enum tableViewCell: String {
        case classRoomHeaderView = "ClassRoomHeaderView"
        case MenuHeaderCell = "HeaderCell"
        case AddElectiveSubjectFooterVw = "AddElectiveSubjectFooterVw"
        case ElectiveSubjectVw = "ElectiveSubjectVw"
           
        
    }
    
}

struct Fonts {
    
    struct HindMadurai {
        static let Regular = "HindMadurai-Regular"
        static let Bold = "HindMadurai-Bold"
        static let Light = "HindMadurai-light"
        static let SemiBold = "HindMadurai-SemiBold"
        static let Medium = "HindMadurai-Medium"
    }
    struct OpenSans {
        static let Regular = "OpenSans-Regular"
        static let Bold = "OpenSans-Bold"
        static let BoldItalic = "OpenSans-BoldItalic"
        static let SemiBold = "OpenSans-Semibold"
        static let Light = "OpenSans-Light"
        static let LightItalic = "OpenSans-LightItalic"
        static let ExtraBold = "OpenSans-ExtraBold"
        static let Italic = "OpenSans-Italic"
        static let SemiBoldItalic = "OpenSans-SemiboldItalic"
        static let ExtraBoldItalic = "OpenSans-ExtraBoldItalic"
    }
    struct NunitoSans {
        static let Black = "NunitoSans-Black"
        static let BlackItalic = "NunitoSans-BlackItalic"
        static let Bold = "NunitoSans-Bold"
        static let BoldItalic = "NunitoSans-BoldItalic"
        static let ExtraBold = "NunitoSans-ExtraBold"
        static let ExtraBoldItalic = "NunitoSans-ExtraBoldItalic"
        static let ExtraLight = "NunitoSans-ExtraLight"
        static let ExtraLightItalic = "NunitoSans-ExtraLightItalic"
        static let Italic = "NunitoSans-Italic"
        static let Light = "NunitoSans-Light"
        static let LightItalic = "NunitoSans-LightItalic"
        static let Regular = "NunitoSans-Regular"
        static let SemiBold = "NunitoSans-SemiBold"
        static let SemiBoldItalic = "NunitoSans-SemiBoldItalic"
    }
    struct Calibri {
        static let Regular = "Calibri"
        static let Bold = "Calibri_Bold"
        
    }
}


class Constants{
    struct Color {
        static let SavanColor = UIColor.init(hexString: "#1B77D0")
        static let ViewBgColor = UIColor.init(hexString: "#FFFFFF")
        static let appColor = UIColor.init(hexString: "#427FC1")
    }
    
}

struct UDKeys{
    
    static let FCM_TOKEN = "fcmtoken"
    static let LOGIN_INFO = "loginInfo"
    static let SIGNUP_INFO = "signupinfo"
    static let BEARER_TOKEN = "Bearer"
    static let IS_PROFILE_COMEPLETE = "ProfileComplete"
    static let IS_ADDRESS_COMEPLETE = "AddressComplete"
    static let IS_LOGGED_IN = "IsloggedIn"
    static let IS_ONLINE = "IsOnline"
}

struct API_NAME{
    
    static let LOGIN = "api/auth/login"
    static let SIGNUP = "api/auth/signup"
    static let OTP_AUTH = "api/auth/second-auth"
    static let FORGOT_PASSWORD = "api/auth/forgot-password"
    static let FORGOT_PASSWORD_VERIFY = "api/auth/verify-forgot-password"
    static let RECOVER_PASSWORD = "api/auth/recover-password"

    static let FAVORITE_LOCATIONS =  "api/driver/favorite-locations"
    static let SAVE_ADDRESS = "api/driver/save-address"
    static let DRIVING_LICENCE_UPLOAD_FRONT = "api/driver/upload-documents/driving-license-front"
    static let DRIVING_LICENCE_UPLOAD_BACK = "api/driver/upload-documents/driving-license-back"
    static let INSURANCE_PROOF = "api/driver/upload-documents/insurance-proof"
    static let VEHICLE_REGISTRATION = "api/driver/upload-documents/vehicle-registration"

    static let SAVE_PREFRENCES = "api/customer/preferences"
    static let CREATE_CARD = "api/customer/create-card"

    static let EDIT_PROFILE = "api/update-profile"
    static let UPLOAD_PROFILE_PIC = "api/upload-picture"
    static let UPDATE_EMAIL =  "api/update-email"
    static let UPDATE_PHONENUMBER =  "api/update-phonenumber"
    static let GET_STATES = "api/states"
    static let GET_LANGUAGES = "api/languages"
    static let CHANGE_PASSWORD = "api/change-password"

    static let PAYMENT_CHARGE = "api/payments/charge"
    static let CUSTOMER_PAST_TRIP = "api/payments/transactions?page=1&type=customer"
    static let GET_HELP_CATEGORIES = "api/help/categories"
    static let SAVE_HELP_REQUEST = "api/help/request"
    static let TERM_CONDITIONS = "api/pages/terms-and-conditions-driver"
    
    static let sendMessage = "api/customer/actions/message"
}


