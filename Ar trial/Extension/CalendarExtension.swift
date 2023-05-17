//
//  CalendarExtension.swift
//  Ar trial
//
//  Created by niudan on 2023/5/12.
//

import Foundation
import SwiftUI

extension Calendar{
    struct WeekDay:Identifiable,Codable{
        var id:UUID = .init()
        var string:String
        var date:Date
        var istoday:Bool=false
    }
    
    
    
    var currentWeek:[WeekDay]{
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else {
            return []
        }
        var week:[WeekDay]=[]
        for index in 0..<7{
            if let day=self.date(byAdding: .day, value: index, to: firstWeekDay){
                let weekdaysymbol:String=day.DatetoString("EEEE")
                let istoday=self.isDateInToday(day)
                week.append(WeekDay(string: weekdaysymbol, date: day))
            }
        }
        return week
    }
    
    
}
