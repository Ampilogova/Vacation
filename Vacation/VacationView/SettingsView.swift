//
//  SettingsView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import SwiftUI

@MainActor
struct SettingsView: View {
    @State private var viewModel = VacationDatesViewModel()
    @State private var hours: String = ""
    @State private var minute: String = ""
    @AppStorage("vacationMinutes") private var vacationMinutes: Int = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            TextField("Hours", text: $hours)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Minute", text: $minute)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button("Save") {
                    if let hoursVacation = Int(hours), let minuteVacation = Int(minute) {
                        viewModel.setupStartDate(startDate: Date.now.timeIntervalSince1970)
                        let min = viewModel.convertToMinutes(hours: hoursVacation, minutes: minuteVacation)
                        vacationMinutes = min
                        dismiss()
                    }
                }
            }
        }
    }
}
