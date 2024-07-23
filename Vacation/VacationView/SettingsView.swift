//
//  SettingsView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var hours: String = ""
    @State private var minute: String = ""
    @AppStorage("vacationHours") private var vacationHours: Int = 0
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
                        vacationHours = hoursVacation
                        vacationMinutes = minuteVacation
                        dismiss()
                    }
                }
            }
        }
    }
}
