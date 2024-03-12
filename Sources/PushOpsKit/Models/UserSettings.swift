import Foundation

public struct PushUserSettings: Codable {
    public let status: String
    public let reason: String
    public let user: User
    public let userFirstName: String
    public let userLastName: String
    public let companyData: [CompanyData]
    public let token: String
    public let chatToken: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case reason
        case user
        case userFirstName
        case userLastName
        case companyData = "data"
        case token
        case chatToken
    }
}

public struct User: Codable {
    let id: Int
    public let email: String
    let uuid: UUID
    public let firstname: String
    public let lastname: String
    public let phone: String?
    let rememberToken: String?
    public let locale: String
    let createdAt: String
    let updatedAt: String
    let resetPassword: Int
    let securityImageID: String?
    let defaultProfileID: String?
    let defaultLocationID: String?
    let emailConfirmedAt: String
    
    init(id: Int, email: String, uuid: String, firstname: String, lastname: String, phone: String?, rememberToken: String?, locale: String, createdAt: String, updatedAt: String, resetPassword: Int, securityImageID: String?, defaultProfileID: String?, defaultLocationID: String?, emailConfirmedAt: String) {
        self.id = id
        self.email = email
        self.uuid = UUID(uuidString: uuid)!
        self.firstname = firstname
        self.lastname = lastname
        self.phone = phone!.isEmpty ? nil : phone
        self.rememberToken = rememberToken
        self.locale = locale
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.resetPassword = resetPassword
        self.securityImageID = securityImageID
        self.defaultProfileID = defaultProfileID
        self.defaultLocationID = defaultLocationID
        self.emailConfirmedAt = emailConfirmedAt
    }
}

public struct CompanyData: Codable {
    public let userID: Int
    public let userUUID: UUID
    public let clockID: Int
    public let companyID: Int
    public let userableID: Int
    public let userableType: String
    public let adminType: String?
    public let company: String
    public let companyAddress: String
    public let companyCity: String
    public let companyProvince: String
    public let companyPostalCode: String
    public let companyStartDate: String
    public let companyStartDay: Int
    public let timesheetStartDay: Int
    public let companyLocations: [String]
    public let companyFeatures: CompanyFeatures
    public let schedulerSettings: SchedulerSettings
    public let clockSettings: ClockSettings
    public let firstname: String
    public let lastname: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userUUID = "userUuid"
        case clockID = "clockId"
        case companyID = "companyId"
        case userableID = "userableId"
        case userableType = "userableType"
        case adminType = "adminType"
        case company = "company"
        case companyAddress = "companyAddress"
        case companyCity = "companyCity"
        case companyProvince = "companyProvince"
        case companyPostalCode = "companyPostalCode"
        case companyStartDate = "companyStartDate"
        case companyStartDay = "companyStartDay"
        case timesheetStartDay = "timesheetStartDay"
        case companyLocations = "companyLocations"
        case companyFeatures = "companyFeatures"
        case schedulerSettings = "schedulerSettings"
        case clockSettings = "clockSettings"
        case firstname = "firstname"
        case lastname = "lastname"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userID = try container.decode(Int.self, forKey: .userID)
        
        if let userUUIDString = try? container.decode(String.self, forKey: .userUUID),
           let uuid = UUID(uuidString: userUUIDString) {
            userUUID = uuid
        } else {
            throw DecodingError.dataCorruptedError(forKey: .userUUID, in: container, debugDescription: "Invalid userUUID format")
        }
        
        if let clockIDString = try? container.decode(String.self, forKey: .clockID),
           let clockIDInt = Int(clockIDString) {
            clockID = clockIDInt
        } else {
            throw DecodingError.dataCorruptedError(forKey: .userID, in: container, debugDescription: "Invalid clockID format")
        }
        
        companyID = try container.decode(Int.self, forKey: .companyID)
        userableID = try container.decode(Int.self, forKey: .userableID)
        userableType = try container.decode(String.self, forKey: .userableType)
        adminType = try container.decodeIfPresent(String.self, forKey: .adminType)
        company = try container.decode(String.self, forKey: .company)
        companyAddress = try container.decode(String.self, forKey: .companyAddress)
        companyCity = try container.decode(String.self, forKey: .companyCity)
        companyProvince = try container.decode(String.self, forKey: .companyProvince)
        companyPostalCode = try container.decode(String.self, forKey: .companyPostalCode)
        companyStartDate = try container.decode(String.self, forKey: .companyStartDate)
        companyStartDay = try container.decode(Int.self, forKey: .companyStartDay)
        timesheetStartDay = try container.decode(Int.self, forKey: .timesheetStartDay)
        companyLocations = try container.decode([String].self, forKey: .companyLocations)
        companyFeatures = try container.decode(CompanyFeatures.self, forKey: .companyFeatures)
        schedulerSettings = try container.decode(SchedulerSettings.self, forKey: .schedulerSettings)
        clockSettings = try container.decode(ClockSettings.self, forKey: .clockSettings)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)
    }
}

public struct CompanyFeatures: Codable {
    let isBreaksEnabled: Bool
    let isChangeApprovalsEnabled: Bool
    let isLogbookEnabled: Bool
    let isSalesLabourDashboardEnabled: Bool
    let isPayrollEnabled: Bool
    let isChatEnabled: Bool
    let isEmployeeProfileEditEnabled: Bool
    let isPayrollBalancesFullDayOnly: Bool
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isBreaksEnabled = try container.decode(Bool.self, forKey: .isBreaksEnabled)
        self.isChangeApprovalsEnabled = try container.decode(Bool.self, forKey: .isChangeApprovalsEnabled)
        self.isLogbookEnabled = try container.decode(Bool.self, forKey: .isLogbookEnabled)
        self.isSalesLabourDashboardEnabled = try container.decode(Bool.self, forKey: .isSalesLabourDashboardEnabled)
        self.isPayrollEnabled = try container.decode(Bool.self, forKey: .isPayrollEnabled)
        self.isChatEnabled = try container.decode(Bool.self, forKey: .isChatEnabled)
        self.isEmployeeProfileEditEnabled = try container.decode(Bool.self, forKey: .isEmployeeProfileEditEnabled)
        
        if let isPayrollBalancesFullDayOnlyInt = try? container.decode(Int.self, forKey: .isPayrollBalancesFullDayOnly),
           let isPayrollBalancesFullDayOnlyBool = (isPayrollBalancesFullDayOnlyInt == 1 ? true : false) {
            self.isPayrollBalancesFullDayOnly = isPayrollBalancesFullDayOnlyBool
        } else {
            throw DecodingError.dataCorruptedError(forKey: .isPayrollBalancesFullDayOnly, in: container, debugDescription: "Invalid isPayrollBalancesFullDayOnly format")
        }
    }
}

public struct ClockSettings: Codable {
    let show: Bool
    let showBreakInput: Bool
}

public struct SchedulerSettings: Codable {
    let showSwaps: Bool
    let showReleases: Bool
    let showAvailability: Bool
    let showDailySchedules: Bool
    let showPayStubs: Bool
    let showHoursWorked: Bool
    let messagesAllowEmployeeCompose: Bool
    let profileEditSin: Bool
    let showPayrollBalances: Bool
    let canEditEmergencyContacts: Bool
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.showSwaps = try container.decode(Int.self, forKey: .showSwaps) == 1
        self.showReleases = try container.decode(Int.self, forKey: .showReleases) == 1
        self.showAvailability = try container.decode(Int.self, forKey: .showAvailability) == 1
        self.showDailySchedules = try container.decode(Int.self, forKey: .showDailySchedules) == 1
        self.showPayStubs = try container.decode(Int.self, forKey: .showPayStubs) == 1
        self.showHoursWorked = try container.decode(Int.self, forKey: .showHoursWorked) == 1
        self.messagesAllowEmployeeCompose = try container.decode(Int.self, forKey: .messagesAllowEmployeeCompose) == 1
        self.profileEditSin = try container.decode(Int.self, forKey: .profileEditSin) == 1
        self.showPayrollBalances = try container.decode(Int.self, forKey: .showPayrollBalances) == 1
        self.canEditEmergencyContacts = try container.decode(Int.self, forKey: .canEditEmergencyContacts) == 1
    }
}
