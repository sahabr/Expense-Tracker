//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Brishti Saha on 5/12/21.
//

import UIKit


class ExpenseListViewController: UIViewController {

    @IBOutlet weak var expenseTotal: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var expenses = Expenses()
    
    struct MonthSection {
        var month: Date
        var expense: [Expense] = []
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        configureSegmentedControl()
        expenses.loadData {
            DispatchQueue.main.async {
                self.sortTable()
                self.expenseUpdate()

            }
        }
        
    }
    
    func expenseUpdate(){
        self.expenseTotal.text = String(format: "$%.2f",self.sumExpense())
        if self.sumExpense() > 0.0 {
            self.expenseTotal.textColor = UIColor.green
        }else{
            self.expenseTotal.textColor = UIColor.red
        }
    }
    
    func configureSegmentedControl(){
        let blackFontColor = [NSAttributedString.Key.foregroundColor : UIColor.black]
        let whiteFontColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(blackFontColor, for: .selected)
        segmentedControl.setTitleTextAttributes(whiteFontColor, for: .normal)
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.borderWidth = 1.0
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ExpenseDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.expense = expenses.expenseArray[selectedIndexPath.row]
        }else{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    func sumExpense()->Double {
        var sum = 0.0
        for expense in expenses.expenseArray{
            if expense.category == "💰 Salary"{
                sum += expense.amount ?? 0.0
            }else{
                sum -= expense.amount ?? 0.0
            }
        }
        return sum
    }
    
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ExpenseDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            expenses.expenseArray[selectedIndexPath.row] = source.expense
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)

        } else {
            let newIndexPath = IndexPath(row: expenses.expenseArray.count, section: 0)
            expenses.expenseArray.append(source.expense)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        sortTable()
        expenseUpdate()
        saveData()
    }
    
    func saveData() {
        expenses.saveData()
    }
    
    func firstDayOfMonth(date: Date) -> Date{
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month], from: date)
        return calender.date(from: components)!
    }
    
    
    var sections = [MonthSection]()
    
    func byMonth(){
        let groups = Dictionary(grouping: expenses.expenseArray) { (expense) -> Date in
            return firstDayOfMonth(date: expense.date)
        }
        self.sections = groups.map(MonthSection.init(month:expense:))
        tableView.reloadData()
    }
    
    func sortTable(){
        
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            expenses.expenseArray.sort(by: {$0.date > $1.date})
            byMonth()
        case 1:

            expenses.expenseArray.sort(by: {$0.amount ?? 0.0  > $1.amount ?? 0.0 })
        default:
            print("Should not be here segment control")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        sortTable()
    }

}


extension ExpenseListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.expense.count
        //return expenses.expenseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let section = self.sections[indexPath.section]
        let expense = section.expense[indexPath.row]
        
        cell.textLabel?.text = section.expense[indexPath.row].category
        if expense.category == "💰 Salary"{
            cell.detailTextLabel?.text = String(format: "+$%.2f", expense.amount!)
            cell.detailTextLabel?.textColor = UIColor.green
        }else{
            cell.detailTextLabel?.text = String(format: "-$%.2f", expense.amount!)
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
        return cell

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = section.month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    
}

