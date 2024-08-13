//
//  SettingsView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import SwiftUI

@MainActor
struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            TextField("Hours", text: $viewModel.hours)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Minute", text: $viewModel.minute)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button("Save", action: {
                    if let hoursVacation = Int($viewModel.hours.wrappedValue),
                    let minuteVacation = Int($viewModel.minute.wrappedValue) {
                        viewModel.setupStartDate(startDate: Date.now.timeIntervalSince1970)
                        let min = viewModel.convertToMinutes(hours: hoursVacation, minutes: minuteVacation)
                        viewModel.vacationMinutes = min
                        dismiss()
                    }
                })
            }
        }
    }
}
