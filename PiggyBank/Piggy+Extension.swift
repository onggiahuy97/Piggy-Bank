//
//  Piggy+Extension.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/27/22.
//

import Foundation

extension Pig {
    var processValue: Double {
        let value = totalSaving / self.priceGoal
        return value > 1.0 ? 1.0 : value
    }
    
    var isPassedDueDate: Bool {
        if let timeInterval = dueDate?.timeIntervalSince(Date()) {
            return timeInterval < 0 ? true : false
        }
        return false
    }
    
    var totalSaving: Double {
        let totalSaving = savingInputs.map { $0.amount }.reduce(0.0, +)
        return totalSaving
    }
    
    var canBuy: Bool {
        return totalSaving > self.priceGoal
    }
    
    var savingInputs: [PigInput] {
        return (pigInputs?.allObjects as? [PigInput] ?? []).sorted(by: { $0.date! > $1.date! })
    }
    
    var onGoingDays: Int {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: self.createdDate ?? Date())
        let to = calendar.startOfDay(for: Date())
        let daysBetween = calendar.dateComponents([.day], from: from, to: to)
        return daysBetween.day ?? 0
    }
}
