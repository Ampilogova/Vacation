//
//  VacationDatesView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI
import SwiftData

struct VacationDatesView: View {
    
//    private var vacationHours = 62
    private let workHours = 4
    
    @State private var destination = ""
    @State private var showCreateVacation = false
    @State private var showCreateSettings = false
    
    @AppStorage("vacationHours") private var vacationHours: Int = 0
    @AppStorage("vacationMinutes") private var vacationMinutes: Int = 0
    @Query(sort: \Vacation.destionation) private var vacations: [Vacation]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Current balance: \(vacationHours / workHours) days")
                Text("Balance after planned vacation: \(vacationBalance(vacationHour: vacations)) days")
                
                List {
                    ForEach(vacations) { vacation in
                        HStack {
                            Text(vacation.destionation)
                            Text(String(vacation.days) + " days")
                        }
                    }
                    .onDelete(perform: delete)
                }
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
            .background(.bar)
        }
    }
    
    func vacationBalance(vacationHour: [Vacation]) -> Int {
        var days = 0
        for vacaion in vacations {
            days += vacaion.days
        }
        return vacationHours / workHours - days
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
    
    private func countFutureVacationHours(vacationTime: VacationTime) -> Int {
//        let hours = vacationTime.hours
//        let minutes = vacationTime.minutes
        
        return 1
    }
}
