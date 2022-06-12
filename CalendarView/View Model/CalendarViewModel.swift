//
//  CalendarViewModel.swift
//  CalendarView
//
//  Created by Coditas on 08/06/22.
//

import Foundation
import RealmSwift

class CalendarViewModel{
    let realm = try! Realm()
    var events : Results<AddEventData>!
    var fetchedData = [AddEventData]()
    
    var dropDownValues : [TechStack] = [
        TechStack(id: 1, value: "Does not repeat"),
        TechStack(id: 2, value: "Daily"),
        TechStack(id: 3, value: "Weekly on Thursday"),
        TechStack(id: 4, value: "Monthly on the first Thursday"),
        TechStack(id: 5, value: "Annualy on 7 July"),
        TechStack(id: 6, value: "Every weekday (Monday to Friday)")
    ]
    
    func saveData(object : AddEventData){
        try! realm.write{
            realm.add(object)
        }
    }
    
    func fetchResult(completion: ([AddEventData])->()){
        events = realm.objects(AddEventData.self)
        for i in events{
            fetchedData.append(i)
        }
        completion(fetchedData)
    }
    
    func getDropDownData() -> [DropDownData]{
        return self.dropDownValues.map{DropDownData(id: $0.id, value: $0.value)}
    }
    
}
