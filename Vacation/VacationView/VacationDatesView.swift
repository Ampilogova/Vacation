//
//  VacationDatesView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI
import SwiftData

struct VacationDatesView: View {
    
    private var vacationHours = 62
    private let workHours = 4
    
    @State private var destination = ""
    @State private var showVacation = false
    @State private var dates: Set<DateComponents> = []
    @State private var newDate = Date.now
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
//            .navigationTitle("Planned vacations")
            .navigationBarItems(trailing: Button(action: {
                showVacation = true
            }, label: {
                Image(systemName: "plus")
            }))
            .popover(isPresented: $showVacation) {
                CreateDestinationView()
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
}
