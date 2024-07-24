//
//  VacationDatesView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI
import SwiftData

struct VacationDatesView: View {
    
    private let workHours = 4
    
    @State private var vacationBalance = 0
    @State private var destination = ""
    @State private var showCreateVacation = false
    @State private var showCreateSettings = false
    @AppStorage("startDate") private var startDateData: Data = Data()
    @AppStorage("vacationHours") private var vacationHours: Int = 0
    @AppStorage("vacationMinutes") private var vacationMinutes: Int = 0
    @Query(sort: \Vacation.destionation) private var vacations: [Vacation]
    @Environment(\.modelContext) var modelContext
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Current balance: \(vacationHours / workHours) days")
                Text("Balance after planned vacation: \(vacationHours / workHours - vacationBalance) days")
                
                List {
                    ForEach(vacations) { vacation in
                        HStack {
                            Text(vacation.destionation)
                                .font(Font.headline.bold())
                            Spacer()
                            Text(convertDateComponents(dates: vacation.dates))
                            Spacer()
                            Text(String(countWorkingDays(dates: vacation.dates)) + " days")
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .onChange(of: vacations) {
                vacationBalance = calculateVacationBalance()
            }
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    showCreateVacation = true
                }, label: {
                    Image(systemName: "plus")
                })
                Button(action: {
                    showCreateSettings = true
                }, label: {
                    Image(systemName: "gear")
                })
            })
            .popover(isPresented: $showCreateVacation) {
                CreateDestinationView()
            }
            .popover(isPresented: $showCreateSettings) {
                SettingsView()
            }
            .onAppear {
                vacationBalance = calculateVacationBalance()
                countFutureVacationHours()
            }
            .background(.bar)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let vacation = vacations[index]
            modelContext.delete(vacation)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error deleting chat: \(error)")
        }
    }
    
    private func convertDateComponents(dates: Set<DateComponents>) -> String {
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
    
    private func convertToString(date: DateComponents) -> String {
        var dateString = ""
        let calendar = Calendar.current
        if let date = calendar.date(from: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY"
            
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    
    private func countWorkingDays(dates: Set<DateComponents>) -> Int {
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
    
    private var startDate: Date {
           get {
               guard let decodedDate = try? JSONDecoder().decode(Date.self, from: startDateData) else {
                   return Date()
               }
               return decodedDate
           }
           set {
               guard let encodedDate = try? JSONEncoder().encode(newValue) else {
                   return
               }
               startDateData = encodedDate
           }
       }
    
    private func countFutureVacationHours() {
        let currentDate = Date()
        let calendar = Calendar.current
        let daysDifference = calendar.dateComponents([.day], from: startDate, to: currentDate).day ?? 0
        let today = Calendar.current.dateComponents([.weekday], from: currentDate)
        
        for i in 0..<daysDifference {
            let dateToCheck = calendar.date(byAdding: .day, value: i, to: startDate) ?? startDate
            let weekday = calendar.component(.weekday, from: dateToCheck)
            let wednesday = 4
            let thursday = 5
            
            if weekday != wednesday && weekday != thursday && !isVacationDay(today) {
                vacationMinutes += 34
                
                if vacationMinutes >= 60 {
                    vacationHours += vacationMinutes / 60
                    vacationMinutes %= 60
                }
            }
        }
        startDateData = try! JSONEncoder().encode(currentDate)
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
    
    
    private func calculateVacationBalance() -> Int {
        return vacations.reduce(0) { total, vacation in
            total + countWorkingDays(dates: vacation.dates)
        }
    }
}
