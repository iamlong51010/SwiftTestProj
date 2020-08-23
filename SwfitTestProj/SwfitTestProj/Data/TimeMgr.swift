//
//  TimeMgr.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

extension Date {
    
    func getFromAdd(offsetSeconds:Int) -> Date {
        let newDate = self.addingTimeInterval(Double(offsetSeconds))
        return newDate
    }
    
    var year : Int {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
            return dateComponents.year!
        }
    }
    
    var month : Int {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
            return dateComponents.month!
        }
    }
    
    var day : Int {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
            return dateComponents.day!
        }
    }
    
    var hour : Int {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
            return dateComponents.hour!
        }
    }
    
    var minute : Int {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
            return dateComponents.minute!
        }
    }
    
    var second : Int {
        get {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
            return dateComponents.second!
        }
    }
    
    func getYearMonthDay() -> (year:Int, month:Int, day:Int) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
        return (dateComponents.year!, dateComponents.month!, dateComponents.day!)
    }
    
    func getHourMinSec() -> (hour:Int, min:Int, sec:Int) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
        return (dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
    }
    
    func getYearMonthDayHourMinSec() -> (year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: TimeZone.current, from: self)
        return (dateComponents.year!, dateComponents.month!, dateComponents.day!, dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
    }
    
    func getYearMonthDayDesc() -> String {
        var year = 0, month = 0, day = 0
        (year,month,day) = getYearMonthDay()
        let desc = String(year) + "-" + String(format: "%02d", month) + "-" + String(format: "%02d", day)
        return desc
    }
    
    func getHourMinSecDesc() -> String {
        var hour = 0, min = 0, sec = 0
        (hour,min,sec) = getHourMinSec()
        let desc = String(format: "%02d", hour) + ":" + String(format: "%02d", min) + ":" + String(format:"%02d", sec)
        return desc
    }
    
    func getYearMonthDayHourMinSecDesc() -> String {
        var year = 0, month = 0, day = 0, hour = 0, min = 0, sec = 0
        (year,month,day,hour,min,sec) = getYearMonthDayHourMinSec()
        let desc = String(year) + "-" + String(format: "%02d", month) + "-" + String(format: "%02d", day) + String(format: " %02d", hour) + ":" + String(format: "%02d", min) + ":" + String(format:"%02d", sec)
        return desc
    }
}
