//
//  CustomDropDown.swift
//  CalendarView
//
//  Created by Coditas on 08/06/22.
//

import UIKit

class CustomDropDown: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBOutlet var view: UIView!
    @IBOutlet weak var dropDownTxtFld: UITextField!
    private var datasource:[DropDownData] = []
    var pickerView = UIPickerView()
    static let identifier = String(describing: CustomDropDown.self)
    
//    var test : [DropDownData] = [
//        DropDownData(id: 1, value: "Does not repeat"),
//        DropDownData(id: 2, value: "Daily"),
//        DropDownData(id: 3, value: "Weekly on Thursday"),
//        DropDownData(id: 4, value: "Monthly on the first Thursday"),
//        DropDownData(id: 5, value: "Annualy on 7 July"),
//        DropDownData(id: 6, value: "Every weekday (Monday to Friday)")
//    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed(CustomDropDown.identifier, owner: self, options: nil)
        addSubview(view)
        dropDownTxtFld.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        dropDownTxtFld.inputView = pickerView
       // setDatasource(dataSource: datasource)
        
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: dropDownTxtFld.bounds.height))
        let iconView = UIImageView(image: UIImage(systemName: "chevron.down"))
        iconView.center = iconContainerView.center
        iconContainerView.addSubview(iconView)
        iconContainerView.tintColor = UIColor.gray
        dropDownTxtFld.rightView = iconContainerView
        dropDownTxtFld.rightViewMode = .always
    }
    func setDatasource(dataSource:[DropDownData]){
        self.datasource = dataSource
        print(datasource)
        dropDownTxtFld.text = dataSource[0].value
        pickerView.reloadAllComponents()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditing(_:)))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        dropDownTxtFld.inputAccessoryView = toolBar
    }
    
//MARK: - Textfield delegate & datasource properties.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pickerView.isHidden = true
        dropDownTxtFld.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
//MARK: - Picker view delegate & datasource properties
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dropDownTxtFld.text = datasource[row].value
    }
}

//Fetch json data
//Set event in calendar view 
//Write function to check selected date and db date matching - then show in table view
