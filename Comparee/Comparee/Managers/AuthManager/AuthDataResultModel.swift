//
//  AuthDataResultModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/6/23.
//

import FirebaseAuth
import Foundation

struct AuthDataResultModel {
    let uid: String
    let email: String?

    init(user: User?) {
        self.uid = user?.uid ?? ""
        self.email = user?.email
    }
}
