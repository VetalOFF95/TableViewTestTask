//
//  FilterViewController.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 28.03.2021.
//

import UIKit

protocol FilterDelegate {
    func setFilter(filter: FilterModel)
}

class FilterViewController: UIViewController {
    
    var delegate: FilterDelegate?
    
    let filterVM = FilterVM()

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var sourceTextView: UITextView!
    
    let categoryPickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        categoryTextField.inputView = categoryPickerView
        countryTextField.inputView = countryPickerView
        
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        filterVM.prepareCountriesData()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        if (categoryTextField.hasText || countryTextField.hasText) &&
            !sourceTextView.text.trim().isEmpty {
            
            let alert = UIAlertController(title: "Woops",
                                          message: "You can't mix sources with country or category",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Ok",
                                          style: .cancel, handler: nil))
            present(alert, animated: true)
        } else if !categoryTextField.hasText &&
                    !countryTextField.hasText &&
                    sourceTextView.text.trim().isEmpty {
            
            let alert = UIAlertController(title: "Woops",
                                          message: "Enter one parameter at least",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Ok",
                                          style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            let filterModel = FilterModel(category: categoryTextField.text!.lowercased(),
                                          country: filterVM.getCountryCode(by: countryTextField.text!),
                                          sources: sourceTextView.text!.trim())
            delegate?.setFilter(filter: filterModel)
            
//            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - Picker
extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case categoryPickerView:
            return filterVM.getNumberOfCategories()
        case countryPickerView:
            return filterVM.getNumberOfCountries()
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case categoryPickerView:
            return filterVM.getCategory(at: row)
        case countryPickerView:
            return filterVM.getCountry(at: row)
        default:
            return "No Data"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case categoryPickerView:
            categoryTextField.text = filterVM.getCategory(at: row)
        case countryPickerView:
            countryTextField.text = filterVM.getCountry(at: row)
        default:
            break
        }
    }
}
