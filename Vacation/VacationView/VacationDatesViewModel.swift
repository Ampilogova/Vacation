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
// add private where needed for properties and functions
class VacationDatesViewModel {
    let workHours = 4 // workingHoursPerDay
    var vacations: [Vacation] = []
    var vacationBalance: Int = 0 // remove ": Int" same below for String and Bool
    var destination: String = ""
    var vto: String = ""
    var showCreateVacation: Bool = false
    var showCreateSettings: Bool = false
    var showAlert: Bool = false
    
    var vacationMinutes: Int { // maybe rename to vacationBalance and instead of Int use VacationTime struct (more on thea below)
        get {
            return UserDefaults.standard.integer(forKey: "vacationMinutes") // I think you can use #function instead of "vacationMinutes"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "vacationMinutes")
        }
    }
    
    var startDateData: TimeInterval? // I think you need to override setter and getter as above and maybe rename to lastUpdateDate
    
    func setupStartDate(startDate: TimeInterval) {
        startDateData = Date.now.timeIntervalSince1970
        UserDefaults.standard.set(startDateData, forKey: "startDateKey")
    }
    
    init() {
        fetchData()
    }
    
    func fetchData() { // maybe rename to updateVacations
        do {
            vacations = try ModelContainer.shared.mainContext.fetch(FetchDescriptor<Vacation>())
         } catch {
             fatalError(error.localizedDescription)
         }
    }
    
    func updateVacationMinutes() { // rename to something like clean up past vacations if needed
        for vacation in vacations {
            for dateComponent in vacation.dates {
                if let date = Calendar.current.date(from: dateComponent) {
                    if date < Date() {
                        vacationMinutes -= 240
                        ModelContainer.shared.mainContext.delete(vacation) // looks like a bug. It will remove vacation on the first date of vacation. Do you want it to stay?
                    }
                    // I think code below not requred anymore for swift data
                    do {
                        try ModelContainer.shared.mainContext.save()
                    } catch {
                        print("Error deleting chat: \(error)")
                    }
                }
            }
        }
    }
    
    
    func totalVacationDays() -> Int { // I think you need to create struct VacationTime which initialize with minutes like VacationTime(minutes: Int). Then you will be able to add computed property to it "var hors: Int { minutes / 60 / workHours }.
        return vacationMinutes / 60 / workHours
    }
    
    func balanceVacationDates() -> Int { // rename to make it clear what this func is doing
        vacationBalance = vacations.reduce(0) { total, vacation in
            total + countWorkingDays(dates: vacation.dates)
       }

        return  vacationMinutes / 60 / workHours - vacationBalance
   }

    // if you will store startDate in the Vacation object then you will be able to get sorted vacations when you fetching it from context
    func sortVacationList() { // seems like this function is unused
        vacations.sort { (vacation1, vacation2) -> Bool in
           
            let date1 = vacation1.dates.compactMap { Calendar.current.date(from: $0) }.sorted().first
            let date2 = vacation2.dates.compactMap { Calendar.current.date(from: $0) }.sorted().first

            if let date1 = date1, let date2 = date2 {
                return date1 < date2
            }
            return false
        }
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
    
    // rename to calculateVacatiobBalance(at date: Date) -> VacationTime
    func checkAvailability(futureDay: Date) -> Int { // replace Int with VacationTime struct
        let calendar = Calendar.current
        let today = Date()
        let daysDifference = calendar.dateComponents([.day], from: today, to: futureDay).day ?? 0
        
        guard daysDifference >= 0 else { return 0 }
        var result = vacationMinutes
        
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
        
        return result / 60 / workHours - vacationBalance
    }
    

    func addVacationHours() { // maybe find better name
        let calendar = Calendar.current
        let startDate = Date(timeIntervalSince1970: startDateData ?? Date.now.timeIntervalSince1970)
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
                vacationMinutes += 34
            }
        }
        startDateData = Date.now.timeIntervalSince1970
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
    
    func submit() {
        let hour = 4.0 // price for 1 hours
        let num = (Double(vto) ?? 0.0) / 60.0
        vacationMinutes -= Int(hour * num)
        vto = "" // why we need this?
    }
    
    // unused?
    func convertToMinutes(hours: Int, minutes: Int) -> Int {
        return hours * 60 + minutes
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let vacation = vacations[index]
            ModelContainer.shared.mainContext.delete(vacation)
        }
        // You may not need code below
        do {
            try ModelContainer.shared.mainContext.save()
        } catch {
            print("Error deleting chat: \(error)")
        }
        // here you need to call fetchData() to make your list updated
    }
    
    // unused?
    func convertDateComponents(dates: Set<DateComponents>) -> String {
       var result = ""
       let array = dates
       let calendar = Calendar.current
       let dates = array.compactMap { calendar.date(from: $0 )}
       let sortedDates = dates.sorted(by: <).compactMap { calendar.dateComponents([.month, .day, .year], from: $0)}
       if let firstdDate = sortedDates.first, let lastDate =  sortedDates.last {
           result = convertToString(date: firstdDate) + " - " + convertToString(date: lastDate)
       }
       return result
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
