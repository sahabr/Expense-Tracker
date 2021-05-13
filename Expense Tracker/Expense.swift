//
//  Expense.swift
//  Expense Tracker
//
//  Created by Brishti Saha on 5/12/21.
//

import Foundation

struct Expense: Codable {
    var amount: Double?
    var date: Date
    var category: String
    var notes: String

}
