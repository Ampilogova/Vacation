//
//  VacationService.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 8/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
protocol VacationService {
    
    var vacations: [Vacation] { get }
    
    var vacationBalance: VacationTime { get }
    
    var workingHours: Int { get }
    
    func futureBalance(at dateComponents: DateComponents) -> VacationTime
    
    func createVacation(_ vacation: Vacation)
    
    func deleteVacation(_ vacation: Vacation)
    
}

@MainActor
class VacationServiceImpl: VacationService {
    
    var workingHours: Int = 4
    let context = ModelContainer.shared.mainContext
    var vacations = [Vacation]()
    
    func fetchVacations() -> [Vacation] {
        let descriptor = FetchDescriptor<Vacation>()
        let result = try? context.fetch(descriptor)
        return result ?? []
    }
    
    func createVacation(_ vacation: Vacation) {
        context.insert(vacation)
        vacations = fetchVacations()
    }
    
    func deleteVacation(_ vacation: Vacation) {
        context.delete(vacation)
        vacations = fetchVacations()
    }
    
    var vacationBalance: VacationTime {
        get {
            let value = UserDefaults.standard.integer(forKey: #function)
            return VacationTime(minutes: value)
        }
        set {
            UserDefaults.standard.setValue(newValue.minutes, forKey: #function)
        }
    }
    
    init() {
        vacations = fetchVacations()
    }
    
    func futureBalance(at dateComponents: DateComponents) -> VacationTime {
        let calendar = Calendar.current
        let today = Date()
        let date = calendar.date(from: dateComponents) ?? .now
        let daysDifference = calendar.dateComponents([.day], from: today, to: date).day ?? 0
        
        guard daysDifference >= 0 else { return VacationTime(minutes: 0) }
        var result = vacationBalance
        
        for i in 0..<daysDifference {
            let dateToCheck = calendar.date(byAdding: .day, value: i, to: today) ?? today
            let components = calendar.dateComponents([.year, .month, .day, .weekday], from: dateToCheck)
            let weekday = calendar.component(.weekday, from: dateToCheck)
            let wednesday = 4
            let thursday = 5
            
            if weekday != wednesday && weekday != thursday && !isVacationDay(at: components) {
                result = result + 34
            }
        }
        return result
    }
    
    func isVacationDay(at dateComponents: DateComponents) -> Bool {
        for vacation in vacations {
            if vacation.dates.contains(where: { date in
                date.day == dateComponents.day &&
                date.month == dateComponents.month &&
                date.year == dateComponents.year
            })  {
                return true
            }
        }
        return false
    }
}
