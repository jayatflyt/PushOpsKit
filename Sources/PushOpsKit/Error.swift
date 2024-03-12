//
//  PushError.swift
//
//
//  Created by May on 8/11/23.
//

import Foundation

public enum PushError: Error {
    case invalidJSON
    case incorrectLogin
    case invalidResponse
}
