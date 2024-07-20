//
//  CreateDestionationView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI

struct CreateDestinationView: View {
    @State private var isSheetPresented = false
    @State private var destination = ""
    @State private var dates: Set<DateComponents> = []
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    let dateRange: ClosedRange<Date>? = {
        let calendar = Calendar.current
        let startComponent = DateComponents(year: 2024, month: 1, day: 1)
        let endComponent = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        if let startDate = calendar.date(from: startComponent), let endDate = calendar.date(from: endComponent) {
            return startDate...endDate
        } else {
            return nil
        }
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Selected Dates: \(dates.count)")
                    .font(.headline)
                Spacer()
                TextField("Destination", text: $destination)
                    .textFieldStyle(.roundedBorder)
                MultiDatePicker("Dates Available", selection: $dates)
                    .frame(height: 500)
            }
            
            .padding()
            .navigationBarItems(trailing: Button(action: {
                isSheetPresented = true
                let newVacation = Vacation(destionation: destination, days: dates.count)
                modelContext.insert(newVacation)
                destination = ""
                dismiss()
            }, label: {
                Text("Done")
            }))
        }
        .bold()
    }
}

