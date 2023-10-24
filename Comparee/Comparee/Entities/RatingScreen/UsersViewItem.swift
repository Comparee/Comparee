//
//  UsersViewItem.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/3/23.
//

import UIKit

struct UsersViewItem: Codable, Equatable, Hashable {
    var id = UUID()
    var userId: String
    var name: String
    var rating: Int
    var instagram: String?
    var currentPlace: Int?
}
