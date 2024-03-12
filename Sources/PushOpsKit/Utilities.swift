//
//  Utilities.swift
//
//
//  Created by May on 10/17/23.
//

import Foundation

/**
 This method will take an array of Shifts and return them sorted by date.
 */

public struct Utilities {
    static public func sortShiftsByDate(shiftsToSort: [Shift]) -> [Shift] {
        return shiftsToSort.sorted(by: {
                $0.scheduledStart.compare($1.scheduledStart) == .orderedAscending
            })
    }
}
