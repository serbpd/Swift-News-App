//
//  FilterPopupController.swift
//  Swift News App
//
//  Created by Paul on 5/7/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit

class FilterPopup: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var catTxtField: UITextField!
    @IBOutlet weak var srcTxtField: UITextField!
    @IBOutlet weak var sortTxtField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    var pickerView: UIPickerView = UIPickerView(frame: .zero)
    var selectedArray: [(name: String, code: String)]!
    var selectedTxtField: UITextField!
    
    let countries: [(name: String, code: String)] = [("Australia", "au"), ("Canada", "ca"), ("Germany", "de"), ("Romania", "ro"), ("United States", "us")]
    let categories: [(name: String, code: String)] = [("Business", "business"), ("Entertainment", "entertainment"), ("General", "general"), ("Health", "health"), ("Science", "science"), ("Sports", "sports"), ("Technology", "technology")]
    let sorts: [(name: String, code: String)] = [("Relevancy", "relevancy"), ("Popularity", "popularity"), ("Date", "publishedAt")]
    let sources: [(name: String, code: String)] = [("BBC News", "bbc-news"), ("Wall Street Journal", "the-wall-street-journal"), ("Fox News", "fox-news"), ("CNN", "cnn"), ("New York Times", "the-new-york-times"), ("CNBC", "cnbc"), ("The Verge", "the-verge")]
    
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
        
        pickerView.delegate = self
        pickerView.dataSource = self
        countryTxtField.delegate = self
        catTxtField.delegate = self
        srcTxtField.delegate = self
        sortTxtField.delegate = self
    }
    
    @IBAction func clearFilters(_ sender: UIButton) {
        pickerView.removeFromSuperview()
        JSONParser.shared.clearParams()
        countryTxtField.text = ""
        catTxtField.text = ""
        srcTxtField.text = ""
        sortTxtField.text = ""
    }
    
    //when a text field is tapped, bring up a picker view with choices based on the tapped field
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
        pickerView.removeFromSuperview()
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        superview?.addSubview(pickerView)
        pickerView.tag = 1337
        textField.endEditing(true)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: pickerView, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: pickerView, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: pickerView, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.3, constant: 0).isActive = true
    }
    
    //pickerView delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedArray[row].name
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
