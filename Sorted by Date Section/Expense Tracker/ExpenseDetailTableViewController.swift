//
//  ExpenseDetailTableViewController.swift
//  Expense Tracker
//
//  Created by Brishti Saha on 5/12/21.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ExpenseDetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
  
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var notesView: UITextView!
    
    var expense: Expense!
    
    
    var categoryList: [String] = [String]()
    var selectedCategory: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.delegate = self
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        amountField.keyboardType = UIKeyboardType.decimalPad
        
        categoryList = ["🍟 Food", "🎬 Entertainment", "💰 Salary", "🛍 Shopping", "🛒 Groceries", "🚃 Travel", "💵 Other"]
        
        if expense == nil{
            expense = Expense(amount: Double(), date: Date(), category: "", notes: "")
            amountField.becomeFirstResponder()
        }
        
        updateUserInterface()

    }
    
    func updateUserInterface(){
        selectedCategory = expense.category
        amountField.text = "\(expense.amount!)"
        datePicker.date = expense.date
        notesView.text = expense.notes
        dateLabel.text = dateFormatter.string(from: expense.date)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        expense = Expense(amount: Double(amountField.text!) , date: datePicker.date, category: selectedCategory, notes: notesView.text)
        
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    

    func numberOfComponents(in pickerView: UIPickerView)->Int {
         return 1
     }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedCategory = categoryList[row]
        return categoryList[row]
    }
    
}

extension ExpenseDetailTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesView.becomeFirstResponder()
        return true
    }
}
