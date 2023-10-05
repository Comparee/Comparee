//
//  UserRating.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/2/23.
//

import Foundation

struct UserRating: Codable{
    var rating: Int
    var userId: String
    
    enum CodingKeys: String, CodingKey {
        case rating, userId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rating, forKey: .rating)
        try container.encode(self.userId, forKey: .userId)
    }
}
