//
//  EventDataModel.swift
//  CalendarView
//
//  Created by Coditas on 08/06/22.
//

import Foundation
import RealmSwift

struct DropDownData : Codable{
    var id : Int
    var value : String
    //var recurringOptions = List<DropDownData>()
}
struct TechStack{
    var id : Int
    var value : String
}

struct EventDataToShowInTable{
    var event : String
    var date : String
    var startTime : String
    var endTime : String
}

class DropdownData : Object{
    @Persisted var id : Int?
    @Persisted var value : String?
    
    convenience init(id: Int, value: String) {
        self.init()
        self.id = id
        self.value = value
    }
}
//var dropDownData : [DropDownData] = [
//    DropDownData(id: 1, value: "Does not repeat"),
//    DropDownData(id: 2, value: "Daily"),
//    DropDownData(id: 3, value: "Weekly on Thursday"),
//    DropDownData(id: 4, value: "Monthly on the first Thursday"),
//    DropDownData(id: 5, value: "Annualy on 7 July"),
//    DropDownData(id: 6, value: "Every weekday (Monday to Friday)")
//]
