//
//  FieldsTypeModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/11/23.
//

import Foundation

struct FieldsTypesModel {
    var isTextEmpty = true
    var fieldsTypes: RegInput
    
    mutating func changeTextState(needChange: Bool) {
        isTextEmpty = needChange
    }
}
