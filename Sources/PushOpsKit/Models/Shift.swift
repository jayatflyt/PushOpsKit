//
//  Schedules.swift
//
//
//  Created by May on 8/11/23.
//

import Foundation

/**
 A struct representative of *one* of the dictionary items sent over in the large blob.
 
 */
public struct Shift: Decodable, Identifiable {
    public let id: Int
    public let employeeID: Int
    public let scheduledStart: Date // Convert from String
    public let scheduledEnd: Date // Convert from String
    public let comments: String
    public let position: Position
    public let employee: Employee
    public let tag: Tag?
    public let shiftChangeID: Int
    public let shiftChangeUserID: Int
    public let shiftPickupUserID: Int
    public let userChangeApproved: Bool // Convert from Int
    public let managerChangeApproved: Bool // Convert from Int
    public let managerNotes: String?
    public let managerUserID: Int
    public let published: Bool // Convert from Int
    public let deleted: Bool // Convert from Int
    public let createdAt: Date // Convert from String
    public let updatedAt: Date // Convert from String
    public let notifiedAt: Date? // Convert from String/Null
    public let createdByUserID: Int
    public let updatedComments: String?
    public let posID: Int?
    public let breakMins: Int // Decode from String because these people cannot program
    public let tagID: Int
    public let regularHours: Int
    public let regularCost: Int
    public let overtimeHours: Int
    public let overtimeCost: Int
    public let doubletimeHours: Int
    public let doubletimeCost: Int
    public let overtimeWeeklyHours: Int
    public let overtimeWeeklyCost: Int
    public let canSwapRelease: Bool // Convert from Int
    public let scheduledStartStr: String
    public let scheduledEndStr: String
    public let scheduledTotaltimeSecs: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case employeeID = "employeeId"
        case scheduledStart
        case scheduledEnd
        case comments
        case position
        case employee
        case tag
        case shiftChangeID = "shiftChangeId"
        case shiftChangeUserID = "shiftChangeUserId"
        case shiftPickupUserID = "shiftPickupUserId"
        case userChangeApproved
        case managerChangeApproved
        case managerNotes
        case managerUserID = "managerUserId"
        case published
        case deleted
        case createdAt
        case updatedAt
        case notifiedAt
        case createdByUserID = "createdByUserId"
        case updatedComments
        case posID = "posId"
        case breakMins
        case tagID = "tagId"
        case regularHours
        case regularCost
        case overtimeHours
        case overtimeCost
        case doubletimeHours
        case doubletimeCost
        case overtimeWeeklyHours
        case overtimeWeeklyCost
        case canSwapRelease
        case scheduledStartStr
        case scheduledEndStr
        case scheduledTotaltimeSecs
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.employeeID = try container.decode(Int.self, forKey: .employeeID)
        self.scheduledStart = try container.decode(Date.self, forKey: .scheduledStart)
        self.scheduledEnd = try container.decode(Date.self, forKey: .scheduledEnd)
        self.comments = try container.decode(String.self, forKey: .comments)
        self.position = try container.decode(Position.self, forKey: .position)
        self.employee = try container.decode(Employee.self, forKey: .employee)
        self.tag = try container.decodeIfPresent(Tag.self, forKey: .tag)
        self.shiftChangeID = try container.decode(Int.self, forKey: .shiftChangeID)
        self.shiftChangeUserID = try container.decode(Int.self, forKey: .shiftChangeUserID)
        self.shiftPickupUserID = try container.decode(Int.self, forKey: .shiftPickupUserID)
        
        if let userChangeApprovedInt = try container.decodeIfPresent(Int.self, forKey: .userChangeApproved) {
            self.userChangeApproved = userChangeApprovedInt == 1 ? true : false
        } else {
            throw DecodingError.dataCorruptedError(forKey: .userChangeApproved, in: container, debugDescription: "Expected to convert Int to be either 0 or 1 for conversion to Bool.")
        }
        
        if let managerChangeApprovedInt = try container.decodeIfPresent(Int.self, forKey: .managerChangeApproved) {
            self.managerChangeApproved = managerChangeApprovedInt == 1 ? true : false
        } else {
            throw DecodingError.dataCorruptedError(forKey: .managerChangeApproved, in: container, debugDescription: "Expected to convert Int to be either 0 or 1 for conversion to Bool.")
        }
        
        self.managerNotes = try container.decodeIfPresent(String.self, forKey: .managerNotes)
        self.managerUserID = try container.decode(Int.self, forKey: .managerUserID)
        
        if let publishedInt = try container.decodeIfPresent(Int.self, forKey: .published) {
            self.published = publishedInt == 1 ? true : false
        } else {
            throw DecodingError.dataCorruptedError(forKey: .published, in: container, debugDescription: "Expected to convert Int to be either 0 or 1 for conversion to Bool.")
        }
        
        if let deletedInt = try container.decodeIfPresent(Int.self, forKey: .deleted) {
            self.deleted = deletedInt == 1 ? true : false
        } else {
            throw DecodingError.dataCorruptedError(forKey: .deleted, in: container, debugDescription: "Expected to convert Int to be either 0 or 1 for conversion to Bool.")
        }
        
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.notifiedAt = try container.decodeIfPresent(Date.self, forKey: .notifiedAt)
        self.createdByUserID = try container.decode(Int.self, forKey: .createdByUserID)
        self.updatedComments = try container.decodeIfPresent(String.self, forKey: .updatedComments)
        self.posID = try container.decodeIfPresent(Int.self, forKey: .posID)
        
        if let breakMinsString = try container.decodeIfPresent(String.self, forKey: .breakMins) {
            self.breakMins = (breakMinsString as NSString).integerValue // vile.
        } else {
            throw DecodingError.dataCorruptedError(forKey: .breakMins, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        self.tagID = try container.decode(Int.self, forKey: .tagID)
        
        if let regularHoursString = try container.decodeIfPresent(String.self, forKey: .regularHours) {
            self.regularHours = (regularHoursString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .regularHours, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let regularCostString = try container.decodeIfPresent(String.self, forKey: .regularCost) {
            self.regularCost = (regularCostString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .regularCost, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let overtimeHoursString = try container.decodeIfPresent(String.self, forKey: .overtimeHours) {
            self.overtimeHours = (overtimeHoursString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .overtimeHours, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let overtimeCostString = try container.decodeIfPresent(String.self, forKey: .overtimeCost) {
            self.overtimeCost = (overtimeCostString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .overtimeCost, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let doubletimeHoursString = try container.decodeIfPresent(String.self, forKey: .doubletimeHours) {
            self.doubletimeHours = (doubletimeHoursString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .doubletimeHours, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let doubletimeCostString = try container.decodeIfPresent(String.self, forKey: .doubletimeCost) {
            self.doubletimeCost = (doubletimeCostString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .doubletimeCost, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let overtimeWeeklyHoursString = try container.decodeIfPresent(String.self, forKey: .overtimeWeeklyHours) {
            self.overtimeWeeklyHours = (overtimeWeeklyHoursString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .overtimeWeeklyHours, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let overtimeWeeklyCostString = try container.decodeIfPresent(String.self, forKey: .overtimeWeeklyCost) {
            self.overtimeWeeklyCost = (overtimeWeeklyCostString as NSString).integerValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .overtimeWeeklyCost, in: container, debugDescription: "Expected to convert String to Int.")
        }
        
        if let canSwapReleaseInt = try container.decodeIfPresent(Int.self, forKey: .canSwapRelease) {
            self.canSwapRelease = canSwapReleaseInt == 1 ? true : false
        } else {
            throw DecodingError.dataCorruptedError(forKey: .canSwapRelease, in: container, debugDescription: "Expected to convert Int to be either 0 or 1 for conversion to Bool.")
        }
        
        self.scheduledStartStr = try container.decode(String.self, forKey: .scheduledStartStr)
        self.scheduledEndStr = try container.decode(String.self, forKey: .scheduledEndStr)
        self.scheduledTotaltimeSecs = try container.decode(Int.self, forKey: .scheduledTotaltimeSecs)
    }
}
