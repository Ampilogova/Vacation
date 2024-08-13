//
//  VacationTime.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import Foundation
import SwiftData

struct VacationTime: Codable {
    var minutes: Int
    
    init(minutes: Int) {
        self.minutes = minutes
    }
    
    func toHours() -> Int {
        return minutes / 60
    }
    
    func toDays() -> Int {
        return toHours() / 4 // TODO: get from settings
    }
    
    static func +(lhs: VacationTime, rhs: VacationTime) -> VacationTime {
        return VacationTime(minutes: lhs.minutes + rhs.minutes)
    }
    
    static func -(lhs: VacationTime, rhs: VacationTime) -> VacationTime {
        return VacationTime(minutes: lhs.minutes - rhs.minutes)
    }
    
    static func *(lhs: VacationTime, rhs: VacationTime) -> VacationTime {
        return VacationTime(minutes: lhs.minutes * rhs.minutes)
    }
    
    static func /(lhs: VacationTime, rhs: VacationTime) -> VacationTime {
        guard rhs.minutes != 0 else {
            fatalError("Division by zero is not allowed")
        }
        return VacationTime(minutes: lhs.minutes / rhs.minutes)
    }
    
    static func +(lhs: VacationTime, rhs: Int) -> VacationTime {
        return VacationTime(minutes: lhs.minutes + rhs)
    }
    
    static func -(lhs: VacationTime, rhs: Int) -> VacationTime {
        return VacationTime(minutes: lhs.minutes - rhs)
    }
    
    static func *(lhs: VacationTime, rhs: Int) -> VacationTime {
        return VacationTime(minutes: lhs.minutes * rhs)
    }
    
    static func /(lhs: VacationTime, rhs: Int) -> VacationTime {
        guard rhs != 0 else {
            fatalError("Division by zero is not allowed")
        }
        return VacationTime(minutes: lhs.minutes / rhs)
    }
}
