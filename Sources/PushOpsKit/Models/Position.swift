import Foundation

/**
 Position class representative of *one* of the objects sent over in the first half of the schedule blob.
 */
public struct Position: Codable, Identifiable {
    public let id: Int
    public let position: String
    public let companyID: Int
    public let colorHex: String?
    public let deletedDatetime: Date?
    public let revenueCentersID: Int
    public let showEndtimes: Bool // Parsed as Int
    public let timesheetEmployeePermissions: String?
    public let departmentID: Int
    public let subDepartmentID: Int?
    public let costcenterID: Int
    public let posID: Int? // Parsed as String
    public let altJobCode: Int? // Parsed as String
    public let locationID: Int?
    public let schedulable: Bool // Parsed as Int
    public let mergePositionID: Int?
    public let minimumWageTypeID: Int?
    public let allowEdit: Int
    public let classificationCode: String?
    public let positionCategoryID: Int?
    public let colours: [Colour]?
    public let department: Department?
    
    enum CodingKeys: String, CodingKey {
        case id
        case position
        case companyID = "companyId" // Map to "company_id" in JSON. The reason for this is the .decodeFromSnakeCase in the caller.
        case colorHex
        case deletedDatetime
        case revenueCentersID = "revenueCentersId"
        case showEndtimes
        case timesheetEmployeePermissions
        case departmentID = "departmentId"
        case subDepartmentID = "subDepartmentId"
        case costcenterID = "costcenterId"
        case posID = "posId"
        case altJobCode
        case locationID = "locationId"
        case schedulable
        case mergePositionID = "mergePositionId"
        case minimumWageTypeID = "minimumWageTypeId"
        case allowEdit
        case classificationCode
        case positionCategoryID = "positionCategoryId"
        case colours
        case department
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.position = try container.decode(String.self, forKey: .position)
        self.companyID = try container.decode(Int.self, forKey: .companyID)
        self.colorHex = try container.decodeIfPresent(String.self, forKey: .colorHex)
        
        // Apply nil if the deletedDatetimeString is an illogical value.
        if let deletedDateTimeString = try container.decodeIfPresent(String.self, forKey: .deletedDatetime) {
            if deletedDateTimeString == "-0001-11-30 00:00:00" {
                deletedDatetime = nil
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: deletedDateTimeString) {
                    deletedDatetime = date
                } else  {
                    throw DecodingError.dataCorruptedError(forKey: .deletedDatetime, in: container, debugDescription: "Expected date string to be in the format 'yyyy-MM-dd HH:mm:ss'")
                }
            }
        } else {
            deletedDatetime = nil
        }
        
        self.revenueCentersID = try container.decode(Int.self, forKey: .revenueCentersID)
        
        if let showEndTimesInt = try container.decodeIfPresent(Int.self, forKey: .showEndtimes) {
            self.showEndtimes = (showEndTimesInt == 1) ? true : false
        } else {
            self.showEndtimes = false
        }
        
        self.timesheetEmployeePermissions = try container.decodeIfPresent(String.self, forKey: .timesheetEmployeePermissions)
        self.departmentID = try container.decode(Int.self, forKey: .departmentID)
        self.subDepartmentID = try container.decodeIfPresent(Int.self, forKey: .subDepartmentID)
        self.costcenterID = try container.decode(Int.self, forKey: .costcenterID)
        
        // pos_id is sent over as a string, for some reason.
        if let posIDString = try container.decodeIfPresent(String.self, forKey: .posID) {
            self.posID = Int(posIDString) ?? nil
        } else {
            posID = nil
        }
        
        if let altJobCodeString = try container.decodeIfPresent(String.self, forKey: .altJobCode) {
            self.altJobCode = Int(altJobCodeString) ?? nil
        } else {
            self.altJobCode = nil
        }
        
        self.locationID = try container.decodeIfPresent(Int.self, forKey: .locationID)
        
        if let schedulableInt = try container.decodeIfPresent(Int.self, forKey: .schedulable) {
            self.schedulable = schedulableInt == 1 ? true : false
        } else {
            throw DecodingError.dataCorruptedError(forKey: .schedulable, in: container, debugDescription: "Expected to convert Int to be either 0 or 1 for conversion to Bool.")
        }
        
        self.mergePositionID = try container.decodeIfPresent(Int.self, forKey: .mergePositionID)
        self.minimumWageTypeID = try container.decodeIfPresent(Int.self, forKey: .minimumWageTypeID)
        self.allowEdit = try container.decode(Int.self, forKey: .allowEdit)
        self.classificationCode = try container.decodeIfPresent(String.self, forKey: .classificationCode)
        self.positionCategoryID = try container.decodeIfPresent(Int.self, forKey: .positionCategoryID)
        self.colours = try container.decodeIfPresent([Colour].self, forKey: .colours)
        self.department = try container.decodeIfPresent(Department.self, forKey: .department)
    }
}

public struct Colour: Codable {
    public let id: Int
    public let positionID: Int
    public let colourHex: String
    public let startTime: Date?
    public let endTime: Date?
    public let createdAt: Date
    public let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case positionID = "positionId"
        case colourHex
        case startTime
        case endTime
        case createdAt
        case updatedAt
    }
    
    public init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.positionID = try container.decode(Int.self, forKey: .positionID)
        self.colourHex = try container.decode(String.self, forKey: .colourHex)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        if let startTimeString = try container.decodeIfPresent(String.self, forKey: .startTime) {
            if startTimeString == "00:00:00" {
                //invalid
                self.startTime = nil
            } else {
                if let date = dateFormatter.date(from: startTimeString) {
                    self.startTime = date
                } else {
                    throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Expected date string to be in the format 'HH:mm:ss'")
                }
            }
        } else {
            self.startTime = nil
        }
        
        if let endTimeString = try container.decodeIfPresent(String.self, forKey: .endTime) {
            if endTimeString == "00:00:00" {
                //invalid
                self.endTime = nil
            } else {
                if let date = dateFormatter.date(from: endTimeString) {
                    self.endTime = date
                } else {
                    throw DecodingError.dataCorruptedError(forKey: .endTime, in: container, debugDescription: "Expected date string to be in the format 'HH:mm:ss'")
                }
            }
        } else {
            self.endTime = nil
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

public struct Department: Codable {
    public let id: Int
    public let companyID: Int
    public let name: String
    public let externalCode: String
    public let createdAt: Date
    public let updatedAt: Date
    public let deletedAt: Date?
    public let revenueCentersID: Int?
    public let locationID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case companyID = "companyId"
        case name
        case externalCode
        case createdAt
        case updatedAt
        case deletedAt
        case revenueCentersID = "revenueCentersId"
        case locationID = "locationId"
    }
    
    init(id: Int, companyID: Int, name: String, externalCode: String, createdAtString: String, updatedAtString: String, deletedAtString: String?, revenueCentersID: Int?, locationID: Int?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // Format of the date strings
        
        self.id = id
        self.companyID = companyID
        self.name = name
        self.externalCode = externalCode
        
        if let createdAt = dateFormatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            fatalError("Failed to convert start time string to Date.")
        }
        
        if let updatedAt = dateFormatter.date(from: updatedAtString) {
            self.updatedAt = updatedAt
        } else {
            fatalError("Failed to convert start time string to Date.")
        }
        
        
        if let deletedAt = dateFormatter.date(from: deletedAtString!) {
            self.deletedAt = deletedAt
        } else {
            self.deletedAt = nil
        }
        
        
        self.revenueCentersID = revenueCentersID
        self.locationID = locationID
    }
}
