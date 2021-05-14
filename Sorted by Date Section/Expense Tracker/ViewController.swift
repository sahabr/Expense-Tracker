//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Brishti Saha on 5/12/21.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var expenseTotal: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var expenses = Expenses()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        expenses.loadData {
            self.tableView.reloadData()
        }
    }


}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.expenseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = expenses.expenseArray[indexPath.row].tag
        cell.detailTextLabel?.text = "\(expenses.expenseArray[indexPath.row].amount)" 
        return cell

    }
    
    
}

