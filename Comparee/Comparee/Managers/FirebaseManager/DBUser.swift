//
//  DBUser.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/11/23.
//

import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    let name: String
    let age: String
    let instagram: String?
    let comparisons: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case name = "name"
        case age = "age"
        case instagram = "instagram"
        case comparisons = "comparisons"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.age, forKey: .age)
        try container.encodeIfPresent(self.instagram, forKey: .instagram)
        try container.encodeIfPresent(self.comparisons, forKey: .comparisons)
    }
}
