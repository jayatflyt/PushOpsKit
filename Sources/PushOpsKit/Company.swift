//
//  Company.swift
//
//
//  Created by May on 9/4/23.
//

import Foundation
import Collections

/**
 A class responsible for managing a single company's data.
 */
public class Company {
    private let router: Router
    private let jsonDecoder = JSONDecoder()
    private let calendar = Calendar(identifier: .gregorian)
    
    public private(set) var companyData: CompanyData
    public private(set) var positions: [Int: Position] // [Position ID: Position Data]
    //TODO: I kind of want to change this to a dictionary and have a static method that sorts it. Depending on swift-collections feels unnessassary for this project. I'd much rather have a method that returns a sorted list as the IDs are already included with the structs.
    public private(set) var schedules: OrderedDictionary<Int, Shift> // Ordered [Shift ID: Shift Data] in order of shift time.
    
    /**
     - parameters:
        - router: The router identified in the `PushOpsKit` class. It should already be initalized and contain all the auth data we need.
        - companyData: The auth method returns company data automatically, so there's no real point in making the same request again when it can be passed.
     */
    init(router: Router, companyData: CompanyData) async throws {
        self.router = router
        self.companyData = companyData
        
        // Initalize Shifts and Positions classes.
        self.positions = [:]
        self.schedules = [:]
        
        try await refreshShifts()
    }
    
    /**
     This method will reset the shifts array and populate it with the current week's shift data. Use `getShiftDate()` to get data for a certain date.
     */
    public func refreshShifts() async throws {
        //initalize JSONDecoder to decode our objects correctly.
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateFormatter = DateFormatter()
            
            // Check for full date format.
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dateString = try? container.decode(String.self) {
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string is not in expected format")
        }
        
        // var so it can be fixed by the below code.
        var data = try await router.makeRequest(path: "/ios/getMySchedules", queryItems: [URLQueryItem(name: "employeeId", value: String(companyData.userableID)), URLQueryItem(name: "companyId", value: String(companyData.companyID))])
//        print(String(data: data, encoding: .utf8))
        
        do {
            /// We are going to manually decode at this point. Trying to turn it into a struct is just not. gonna work.
            if var decodedJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] { // TODO: This is running twice??? Why???
                
                // Decode companyPositions
                if let companyPositionsData = decodedJSON["companyPositions"] as? String {
                    do {
                        self.positions = try jsonDecoder.decode([Int: Position].self, from: companyPositionsData.data(using: .utf8)!)
                    } catch {
                        print("Error decoding companyPositions: \(error)")
                    }
                }
                print("Company Positions Count: \(positions.keys.count)")
                
                let shiftDate = ISO8601DateFormatter().date(from: decodedJSON["startDate"] as! String)
                
                // Decode Shifts
                //TODO: if let is returning false? Why?
                do {
                    // Chaos.
                    let decodedShifts = try jsonDecoder.decode([Int: Shift].self, from: JSONSerialization.data(withJSONObject: decodedJSON["mySchedules"]!))
                    print("\(decodedShifts)")
                    
                    print("DecodedShifts Count: \(decodedShifts.count)")
                                        
                    // Sort the shifts into our desired format of [ID: Shift]
                    // This language is so cool man.
                    let sortedSchedules: [Shift] = decodedShifts.values
                        .sorted(by: {
                            $0.scheduledStart.compare($1.scheduledStart) == .orderedAscending
                        })
                    
                    var scheduleDictionary: OrderedDictionary<Int, Shift> = [:]
                    
                    // Elements are already sorted by date, so add in order of the array.
                    for e in sortedSchedules {
                        scheduleDictionary[e.id] = e
                    }
                    
                    self.schedules = scheduleDictionary
                    print("Parsed mySchedules")
                } catch {
                    print("Error decoding mySchedules: \(error)")
                }
                
                print("Schedules Count: \(schedules.keys.count)")
            }
        } catch {
            print("Error parsing JSON: \(error)")
            throw PushError.invalidJSON
        }
    }
    
    /**
     Use this method to figure out where
     */
    private func sortAndApplyDateSet(shiftSet: [Int: Shift], startingDate: Date) {
        
    }
}
