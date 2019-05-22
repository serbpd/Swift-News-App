//
//  FilterPopupController.swift
//  Swift News App
//
//  Created by Paul on 5/7/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class FilterPopup: UIView, UITextFieldDelegate {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var catTxtField: UITextField!
    @IBOutlet weak var srcTxtField: UITextField!
    @IBOutlet weak var sortTxtField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    var dropDown: DropDown = DropDown(frame: .zero)
    var selectedArray: [(name: String, code: String)]!
    var selectedTxtField: UITextField!
    
    let countries: [(name: String, code: String)] = [("Australia", "au"), ("Canada", "ca"), ("Germany", "de"), ("Romania", "ro"), ("United States", "us")]
    let categories: [(name: String, code: String)] = [("Business", "business"), ("Entertainment", "entertainment"), ("General", "general"), ("Health", "health"), ("Science", "science"), ("Sports", "sports"), ("Technology", "technology")]
    let sorts: [(name: String, code: String)] = [("Relevancy", "relevancy"), ("Popularity", "popularity"), ("Date", "publishedAt")]
    let sources: [(name: String, code: String)] = [("BBC News", "bbc-news"), ("CNBC", "cnbc"), ("CNN", "cnn"), ("Fox News", "fox-news"), ("New York Times", "the-new-york-times"), ("The Verge", "the-verge"), ("Wall Street Journal", "the-wall-street-journal")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "FilterPopup", bundle: Bundle(for: type(of: self)))
        popupView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        popupView.frame = bounds
        popupView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(popupView)
        
        countryTxtField.delegate = self
        catTxtField.delegate = self
        srcTxtField.delegate = self
        sortTxtField.delegate = self
        
        dropDown.direction = .bottom
        dropDown.cornerRadius = 10
        dropDown.dismissMode = .onTap
        dropDown.selectionBackgroundColor = .orange
        dropDown.selectionAction = { (index, item) in
            //fill the tapped field with selected text, and build parameters for a new search request
            self.selectedTxtField.text = self.selectedArray[index].name
            if self.selectedTxtField == self.countryTxtField {
                JSONParser.shared.paramCountry = self.selectedArray[index].code
            } else if self.selectedTxtField == self.catTxtField {
                JSONParser.shared.paramCat = self.selectedArray[index].code
            } else if self.selectedTxtField == self.srcTxtField {
                JSONParser.shared.paramSrc = self.selectedArray[index].code
            } else if self.selectedTxtField == self.sortTxtField {
                JSONParser.shared.paramSort = self.selectedArray[index].code
            }
        }
    }
    
    @IBAction func clearFilters(_ sender: UIButton) {
        dropDown.hide()
        JSONParser.shared.clearParams()
        countryTxtField.text = ""
        catTxtField.text = ""
        srcTxtField.text = ""
        sortTxtField.text = ""
    }
    
    //when a text field is tapped, bring up a dropdown with choices based on the tapped field
    //keep track of the selection
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryTxtField {
            selectedArray = countries
        } else if textField == catTxtField {
            selectedArray = categories
        } else if textField == srcTxtField {
            selectedArray = sources
        } else if textField == sortTxtField {
            selectedArray = sorts
        }
        selectedTxtField = textField
        dropDown.dataSource = selectedArray.map{ $0.name }
        dropDown.anchorView = selectedTxtField
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.reloadAllComponents()
        dropDown.show()
        dropDown.tag = 1337
        textField.endEditing(true)
    }
    
    //pickerView delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedArray.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: selectedArray[row].name, attributes: [.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //fill the tapped field with selected text, and build parameters for a new search request
        selectedTxtField.text = selectedArray[row].name
        if selectedTxtField == countryTxtField {
            JSONParser.shared.paramCountry = selectedArray[row].code
        } else if selectedTxtField == catTxtField {
            JSONParser.shared.paramCat = selectedArray[row].code
        } else if selectedTxtField == srcTxtField {
            JSONParser.shared.paramSrc = selectedArray[row].code
        } else if selectedTxtField == sortTxtField {
            JSONParser.shared.paramSort = selectedArray[row].code
        }
    }
}
