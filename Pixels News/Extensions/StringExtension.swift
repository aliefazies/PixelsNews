//
//  StringExtension.swift
//  Pixels News
//
//  Created by Alief Azies on 22/10/21.
//

import Foundation

enum DateFormat: String{
    case date = "yyyy-MM-dd"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
}

extension String{
    func date(format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
