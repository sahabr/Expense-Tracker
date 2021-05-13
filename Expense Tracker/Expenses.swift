//
//  Expenses.swift
//  Expense Tracker
//
//  Created by Brishti Saha on 5/12/21.
//

import Foundation

class Expenses {
    var expenseArray: [Expense] = []
    
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("expenses").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(expenseArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        }catch{
            print("Could not save data \(error.localizedDescription)")
        }
        //setNotifications()
    }
    
    func loadData(completed: @escaping ()->() ){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("expenses").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            expenseArray = try jsonDecoder.decode(Array<Expense>.self, from: data)
            
        }catch {
            print("😡 Could not load data \(error.localizedDescription)")
        }
        completed()
    }
    
}
