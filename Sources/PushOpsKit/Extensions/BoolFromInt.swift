//
//  BoolFromInt.swift
//
//
//  Created by May on 10/17/23.
//

import Foundation

@propertyWrapper
struct BoolFromInt: Decodable {
    let wrappedValue: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try container.decode(Int.self)
        switch intValue {
        case 0: wrappedValue = false
        case 1: wrappedValue = true
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected `0` or `1` but received `\(intValue)`")
        }
    }
}
