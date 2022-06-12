//
//  ViewController.swift
//  CalendarView
//
//  Created by Coditas on 02/06/22.
//

import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var addEventButtn: UIButton!
    @IBOutlet weak var showEventTableView: UITableView!
    
    var calendarVM = CalendarViewModel()
    let dateFormatter = DateFormatter()
    var selectedDate : String = ""
    var dataFromDb = [AddEventData]()
    var eventData = [EventDataToShowInTable]()
    let gregorian = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEventButtn.layer.cornerRadius = CGFloat(addEventButtn.layer.bounds.width/2)
        addEventButtn.addTarget(self, action: #selector(addEventButtnClicked), for: .touchUpInside)
        print("Today's date",calendarView.currentPage)
       // dateFormatter.dateFormat = "E, dd-MM-YYYY"
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let convertedDate = dateFormatter.string(from: calendarView.currentPage)
        print("convertedDate",convertedDate)
        selectedDate = convertedDate
        calendarVM.fetchResult { data in
            self.dataFromDb = data
            print("DataFromDB", self.dataFromDb)
        }
        dataAdd()
        showEventTableView.register(UINib(nibName: ShowEventTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ShowEventTableViewCell.identifier)
        
        showEventTableView.tableFooterView = UIView()
        
    }
    func dataAdd(){
        eventData = [EventDataToShowInTable(event: "Test1", date: "Tue, 01-01-2022", startTime: "10:00AM", endTime: "11:00PM"),
        EventDataToShowInTable(event: "Test2", date: "Wed, 02-01-2022", startTime: "10:00AM", endTime: "11:00PM"), EventDataToShowInTable(event: "Test3", date: "Thurs, 03-01-2022", startTime: "10:00AM", endTime: "11:00PM")]
    }
    @objc func addEventButtnClicked(){
        if let addEventVC = (self.storyboard?.instantiateViewController(withIdentifier: AddEventViewController.identifier) as? AddEventViewController){
            addEventVC.modalPresentationStyle = .overCurrentContext
            addEventVC.dateSelected = selectedDate
            self.present(addEventVC, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let convertedDate = dateFormatter.string(from: date)
        selectedDate = convertedDate
        print("Date",convertedDate)
    }
   
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let dateString = dateFormatter.string(from: date)
        for i in eventData{
            if i.date == dateString{
                print("yes")
                return [UIColor.blue]
            }
            print("no")
            return [UIColor.white]
        }
        return [UIColor.white]
    }
 
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = dateFormatter.string(from: date)
        for i in eventData{
            if i.date == dateString{
                print("yes 2")
                return 1
            }
            print("no 2")
            return 0
        }
        return 0
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = showEventTableView.dequeueReusableCell(withIdentifier: ShowEventTableViewCell.identifier, for: indexPath) as? ShowEventTableViewCell{
            cell.EventLbl.text = eventData[indexPath.row].event
            cell.timeLbl.text = "\(eventData[indexPath.row].startTime) - \(eventData[indexPath.row].endTime)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            print("edit")
            let editVc  = self.storyboard?.instantiateViewController(withIdentifier: AddEventViewController.identifier) as? AddEventViewController
           // editVc?.caseToWorkOn = .edit
           // editVc?.milkDataToEdit = self.allDataInResult[indexPath.row]
            editVc?.modalPresentationStyle = .overCurrentContext
            self.present(editVc!, animated: true, completion: nil)
            
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print("delete")
           // let deleteFromRealm = self.billViewModel.objectOfResult[indexPath.row]
           // self.billViewModel.deleteData(object: deleteFromRealm)
            self.eventData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipeConfiguration
    }
    
}

