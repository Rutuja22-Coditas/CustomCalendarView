//
//  AddEventData.swift
//  CalendarView
//
//  Created by Coditas on 08/06/22.
//

import Foundation
import RealmSwift

class AddEventData: Object{
   @Persisted var id : String?
   @Persisted var event : String = ""
   @Persisted var date : String = ""
   @Persisted var startTime : String = ""
   @Persisted var endTime : String = ""
   @Persisted var recurringOption : List<DropdownData>
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
