//
//  VacationDatesViewModel.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/28/24.
//

import SwiftUI
import SwiftData

@MainActor
@Observable
class VacationDatesViewModel {
    
    var vacationService: VacationService
    var destination: String = ""
    var vto: String = ""
    var showCreateVacation: Bool = false
    var showCreateSettings: Bool = false
    var showAlert: Bool = false
    var vacationHoursMinutes = ""
    
    var vacations: [Vacation] {
        return vacationService.vacations
    }
    var balanceTitle: String {
        let balance = vacationService.vacationMinutes / 60 / vacationService.workingHours
        return "Current balance: \(balance) days"
    }
    
    var vacationBalance: Int { // to do: move to serive.
        let vacationBalance = vacations.reduce(0) { total, vacation in
            total + countWorkingDays(dates: vacation.dates)
        }
        return vacationBalance
    }
    
    var balanceVacationDates: String {
        let result = vacationService.vacationMinutes / 60 / vacationService.workingHours - vacationBalance
        return "Balance after planned vacation: \(result) days"
    }
    
    var vacationDates: String {
        var result = ""
        for vacation in vacations {
            let calendar = Calendar.current
            let dates = vacation.dates.compactMap { calendar.date(from: $0 )}
            let sortedDates = dates.sorted(by: <).compactMap { calendar.dateComponents([.month, .day, .year], from: $0)}
            if let firstdDate = sortedDates.first, let lastDate =  sortedDates.last {
                result = convertToString(date: firstdDate) + " - " + convertToString(date: lastDate)
            }
        }
        return result
    }
    
    var workingDays: String { // doesn't work
        var result = 0
        for vacation in vacations {
            result += countWorkingDays(dates: vacation.dates)
        }
        return ("\(result) days")
    }
    
    func countWorkingDays(dates: Set<DateComponents>) -> Int {
       var count = 0
       let wednesday = 4
       let thursday = 5
       for date in dates {
           if let weekday = date.weekday {
               if weekday != wednesday && weekday != thursday {
                   count += 1
               }
           }
       }
       return count
   }
    
    init(vacationService: VacationService) {
        self.vacationService = vacationService
    }
    
    func convertToHoursMinutes() -> String {
        let time = vacationService.vacationMinutes
        let hour = time / 60
        let minute = time % 60
        vacationHoursMinutes = String(hour) + "h " + String(minute) + "m"
        return vacationHoursMinutes
    }
    
    func upDateData() {
        addVacationHours()
        updateVacationMinutes()
    }
    
    func updateVacationMinutes() {
        for vacation in vacations {
            for dateComponent in vacation.dates {
                if let date = Calendar.current.date(from: dateComponent) {
                    if date < Date() {
                        vacationService.vacationMinutes -= 240
                        ModelContainer.shared.mainContext.delete(vacation)
                    }
                }
            }
        }
    }
    
    func checkAvailability(futureDay: Date) -> Int {
        let calendar = Calendar.current
        let today = Date()
        let daysDifference = calendar.dateComponents([.day], from: today, to: futureDay).day ?? 0
        
        guard daysDifference >= 0 else { return 0 }
        var result = vacationService.vacationMinutes
        
        for i in 0..<daysDifference {
            let dateToCheck = calendar.date(byAdding: .day, value: i, to: today) ?? today
            let components = calendar.dateComponents([.year, .month, .day, .weekday], from: dateToCheck)
            let weekday = calendar.component(.weekday, from: dateToCheck)
            let wednesday = 4
            let thursday = 5
            
            if weekday != wednesday && weekday != thursday && !isVacationDay(components) {
                result += 34
            }
        }
        
        return result / 60 / vacationService.workingHours - vacationBalance
    }
    

    func addVacationHours() {
        let calendar = Calendar.current
        let startDate = Date(timeIntervalSince1970: vacationService.lastUpdateDate)
        guard !calendar.isDateInToday(startDate) else {
            return
        }
        let currentDate = Date()
        
        let daysDifference = calendar.dateComponents([.day], from: startDate, to: currentDate).day ?? 0
        let today = Calendar.current.dateComponents([.weekday], from: currentDate)
        for i in 0..<daysDifference {
            let dateToCheck = calendar.date(byAdding: .day, value: i, to: startDate) ?? startDate
            let weekday = calendar.component(.weekday, from: dateToCheck)
            let wednesday = 4
            let thursday = 5
            
            if weekday != wednesday && weekday != thursday && !isVacationDay(today) {
                vacationService.vacationMinutes += 32
            }
        }
        vacationService.lastUpdateDate = Date.now.timeIntervalSince1970
    }
    
    func isVacationDay(_ dateComponents: DateComponents) -> Bool {
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
    
    func submitVTO() {
        let hour = 4.0 // price for 1 hours
        let num = (Double(vto) ?? 0.0) / 60.0
        vacationService.vacationMinutes -= Int(hour * num)
        vto = ""
    }
    
    func deleteVacation(at offsets: IndexSet) {
        for index in offsets {
            let vacation = vacations[index]
            vacationService.deleteVacation(vacation)
        }
    }
    
    func convertToString(date: DateComponents) -> String {
       var dateString = ""
       let calendar = Calendar.current
       if let date = calendar.date(from: date) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd.MM.YY"
           
           dateString = dateFormatter.string(from: date)
       }
       return dateString
   }
}

