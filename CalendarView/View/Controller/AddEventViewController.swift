//
//  AddEventViewController.swift
//  CalendarView
//
//  Created by Coditas on 03/06/22.
//

import UIKit
import RealmSwift


enum AlertToShow{
    case addEventTxtView
    case startTimeTxtFld
    case endTimeTxtFld
    case saveData
}

class AddEventViewController: UIViewController {

    @IBOutlet weak var addEventView: UIView!
    @IBOutlet weak var addEventTitle: UILabel!
    @IBOutlet weak var addEventTxtView: UITextView!
    @IBOutlet weak var addDateAndTimeLbl: UILabel!
    @IBOutlet weak var datetxtFld: UITextField!
    @IBOutlet weak var startTimeTxtFld: UITextField!
    @IBOutlet weak var endTimeTxtFld: UITextField!

    @IBOutlet weak var recurringOptDropDown: CustomDropDown!
    
    @IBOutlet weak var saveButtn: UIButton!
    @IBOutlet weak var dismissButtn: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerTabBarView: UIView!
    
    @IBOutlet weak var addeventViewTopConstraint: NSLayoutConstraint!//217
    @IBOutlet weak var addEventBottomConstraint: NSLayoutConstraint!//217
    
    @IBOutlet weak var datePickerHtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewAlertLbl: UILabel!
    @IBOutlet weak var startTimeAlertLbl: UILabel!
    @IBOutlet weak var endTimeAlertLbl: UILabel!
    
    static let identifier = String(describing: AddEventViewController.self)
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var dateSelected : String = ""
    var selectedTimeTxtfld : UITextField!
    
    var validationCheck : AlertToShow!
    var dropDownData = [DropDownData]()
    
    static var addEventIdentifier = String(describing: AddEventViewController.self)
    
    let realm = try! Realm()
    let realmEvent = AddEventData()
    
    var calendarVM = CalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("realm", Realm.Configuration.defaultConfiguration.fileURL!)

        datetxtFld.text = dateSelected
        
        setUpUI()
        datetxtFld.delegate = self
        startTimeTxtFld.delegate = self
        endTimeTxtFld.delegate = self
        addEventTxtView.delegate = self
        datePicker.isHidden = true
        datePickerTabBarView.isHidden = true
        dismissButtn.addTarget(self, action: #selector(dismissButtnClicked), for: .touchUpInside)
        saveButtn.addTarget(self, action: #selector(saveButtnClicked), for: .touchUpInside)
        
        recurringOptDropDown.setDatasource(dataSource: calendarVM.getDropDownData())
        
    }
   
    @objc func dismissButtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func DoneButtnClickedOnDatePicker(_ sender: UIButton) {
        if datePicker.datePickerMode == .date{
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "E, dd MM yyyy"
            let date = dateFormatter.string(from: datePicker.date)
            datetxtFld.text = date
            datePicker.isHidden = true
            datePickerTabBarView.isHidden = true
            datetxtFld.resignFirstResponder()
        }
            
        if datePicker.datePickerMode == .time{
            timeFormatter.dateFormat = "hh:mm a"
            
            if selectedTimeTxtfld == startTimeTxtFld{
                startTimeTxtFld.text = timeFormatter.string(from: datePicker.date)
                startTimeTxtFld.resignFirstResponder()
                datePicker.isHidden = true
                datePickerTabBarView.isHidden = true
            }
            else if selectedTimeTxtfld == endTimeTxtFld {
                endTimeTxtFld.text = timeFormatter.string(from: datePicker.date)
                endTimeTxtFld.resignFirstResponder()
                datePicker.isHidden = true
                datePickerTabBarView.isHidden = true
            }
//            endTimeTxtFld.text = timeFormatter.string(from: datePicker.date)
//            endTimeTxtFld.resignFirstResponder()
        }
//        if endTimeTxtFld.text?.count == 0{
//            endTimeAlertLbl.isHidden = false
//        }
//        else{
//            endTimeAlertLbl.isHidden = true
//        }
        
    }
    
    @IBAction func cancelButtnClickedOnDatePicker(_ sender: UIButton) {
        addEventTxtView.resignFirstResponder()
        startTimeTxtFld.resignFirstResponder()
        endTimeTxtFld.resignFirstResponder()

        datePickerTabBarView.isHidden = true
        datePicker.isHidden = true
    }
    
    @objc func saveButtnClicked(){
        //if textfld and 2 txt flds are empty then show theror alert mess. and add action of disappearing those alert lbls on enterting data in those txtflds.
        //add not accepting space code for text view.
        if addEventTxtView.textColor == .lightGray {
            textViewAlertLbl.isHidden = false
        }
        if startTimeTxtFld.text!.isEmpty {
            startTimeAlertLbl.isHidden = false
        }
        if endTimeTxtFld.text!.isEmpty{
            endTimeAlertLbl.isHidden = false
        }
        else{
            realmEvent.event = addEventTxtView.text!
            realmEvent.date = datetxtFld.text!
            realmEvent.startTime = startTimeTxtFld.text!
            realmEvent.endTime = endTimeTxtFld.text!
            
            realmEvent.id = UUID().uuidString
            calendarVM.saveData(object: realmEvent)
            self.dismiss(animated: true)
        }
        
    }
    
    func setUpUI(){
        print("dateselected",dateSelected)
        view.backgroundColor = UIColor(white: 30/255.0, alpha: 0.6)
        
        addEventTxtView.text = "Add Event"
        addEventTxtView.textColor = UIColor.lightGray
        addEventView.layer.cornerRadius = 10
        addEventTxtView.layer.borderColor = UIColor.systemGray5.cgColor
        addEventTxtView.layer.borderWidth = 1.0
        addEventTxtView.layer.cornerRadius = 5.0
        datePicker.backgroundColor = UIColor.white
        
        datePickerTabBarView.layer.cornerRadius = 5.0
        datePicker.layer.cornerRadius = 20
        
        datePicker.backgroundColor = UIColor(red: 206/255, green: 209/255, blue: 214/255, alpha: 1.0)
        datePickerTabBarView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addEventTxtView.resignFirstResponder()
        startTimeTxtFld.resignFirstResponder()
        endTimeTxtFld.resignFirstResponder()
        recurringOptDropDown.dropDownTxtFld.resignFirstResponder()
    }
    func datePickerSetUp(){
        if !datePicker.isHidden{
            addeventViewTopConstraint.constant = 100
            addEventBottomConstraint.constant = 334
        }else{
            addeventViewTopConstraint.constant = 217
            addEventBottomConstraint.constant = 217
        }
    }
//    func validationWhileSavingData(){
//        switch validationCheck{
//        case .addEventTxtView:
//            textViewAlertLbl.isHidden = false
//        case .startTimeTxtFld:
//            startDateAlertLbl.isHidden = false
//        case .endTimeTxtFld:
//            endDateAlertLbl.isHidden = false
//        case .saveData:
//            realmEvent.date = datetxtFld.text!
//            realmEvent.startTime = startTimeTxtFld.text!
//            realmEvent.endTime = endTimeTxtFld.text!
//            realmEvent.id = UUID().uuidString
//            try! realm.write{
//                realm.add(realmEvent)
//            }
//        case .none:
//            print("Something is missing")
//        }
//
//    }
    func textViewSetUp(){
        
    }
 
//    func textFldSelection(){
//        switch selectedTxtFld{
//        case .dateTxtFld:
//            datePicker.isHidden = false
//            datePickerTabBarView.isHidden = false
//            datePickerSetUp()
//        }
//    }
}


extension AddEventViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == datetxtFld || textField == startTimeTxtFld || textField == endTimeTxtFld{
            datePicker.isHidden = false
            datePickerTabBarView.isHidden = false
            datePicker.datePickerMode = .date
            datePickerSetUp()
            if textField == startTimeTxtFld || textField == endTimeTxtFld{
                datePickerHtConstraint.constant = 200
                datePicker.datePickerMode = .time
                //datePicker.preferredDatePickerStyle = .wheels
                datePicker.backgroundColor = UIColor.white
            }
            else{
                datePickerHtConstraint.constant = 250
            }
        }
        else{
            datePicker.isHidden = true
            datePickerTabBarView.isHidden = true
            datePickerSetUp()
        }
        
        if textField == startTimeTxtFld{
            selectedTimeTxtfld = textField
        }
        else{
            selectedTimeTxtfld = endTimeTxtFld
        }
//         if textField == startTimeTxtFld || textField == endTimeTxtFld{
//            datePicker.isHidden = false
//            datePickerTabBarView.isHidden = false
//            datePicker.datePickerMode = .time
//            datePickerSetUp()
//        }
//        else{
//            datePicker.datePickerMode = .date
//            datePicker.isHidden = true
//            datePickerTabBarView.isHidden = true
//            datePickerSetUp()
//        }
        if textField == recurringOptDropDown.dropDownTxtFld{
            datePicker.isHidden = true
            textField.resignFirstResponder()
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
//        if endTimeTxtFld.text?.count == 0{
//            endDateAlertLbl.isHidden = false
//        }
//        else{
//            endDateAlertLbl.isHidden = true
//
//        }
        return false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == startTimeTxtFld && !startTimeTxtFld.text!.isEmpty{
//            startDateAlertLbl.isHidden = true
//        }
//        if textField == endTimeTxtFld && !endDateAlertLbl.text!.isEmpty{
//            startDateAlertLbl.isHidden = true
//        }
        if startTimeTxtFld.text?.count == 0 {
            startTimeAlertLbl.isHidden = false
        }
        else{
            startTimeAlertLbl.isHidden = true
        }
        
        if endTimeTxtFld.text?.count == 0{
            endTimeAlertLbl.isHidden = false
        }
        else{
            endTimeAlertLbl.isHidden = true
        }
        view.endEditing(true)
        
        
    }
    
}
//250
extension AddEventViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
print("textV")
//        textView.becomeFirstResponder()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
//        self.view.addGestureRecognizer(tapGesture)
        
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
            textViewAlertLbl.isHidden = false
        }
      //  textView.textColor == UIColor.lightGray ? textViewAlertLbl.isHidden : !textViewAlertLbl.isHidden
        
        
        if textView == addEventTxtView{
           // datePicker.isHidden = true
           // buttonsForDatePicker.isHidden = true
           // priorityPickerView.isHidden = true
            // view.endEditing(true)
        }

    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == addEventTxtView{
            if textView.text.count <= 0 {
                  textView.text = "Add Event"
                textView.textColor = UIColor.lightGray
                textViewAlertLbl.isHidden = false
              }
//            else{
//                textViewAlertLbl.isHidden = true
//            }

        }
        view.endEditing(true)
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if addEventTxtView.textColor == .black{
            textViewAlertLbl.isHidden = true
        }
        if addEventTxtView.text.count <= 0{
            textViewAlertLbl.isHidden = false
        }
        guard range.location == 0 else {
            return true
        }
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    
}
