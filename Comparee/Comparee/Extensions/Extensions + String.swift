//
//  Extensions + String.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/3/23.
//

import Foundation

extension String? {
    var unwrappedValue: String {
        return self ?? ""
    }
}
