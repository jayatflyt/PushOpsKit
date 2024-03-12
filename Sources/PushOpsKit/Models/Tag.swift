//
//  PushTag.swift
//
//
//  Created by May on 8/22/23.
//

import Foundation

public struct Tag: Codable {
    let id: Int
    let companyId: Int
    let name: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    let colourHex: String?
}
