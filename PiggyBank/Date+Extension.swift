//
//  Date+Extension.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/27/22.
//

import Foundation
 
extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
