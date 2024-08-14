//
//  SettingsViewModel.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 8/12/24.
//

import Foundation
import SwiftUI

class SettingsViewModel {
    
    var hours: String = ""
    var minute: String = ""
    var startDateData: TimeInterval?
    
    @AppStorage("vacationMinutes") var vacationMinutes: Int = 0
    
    func setupStartDate(startDate: TimeInterval) {
        startDateData = Date.now.timeIntervalSince1970
        UserDefaults.standard.set(startDateData, forKey: "startDateKey")
    }
    
    func saveMinutes() {
        if let hoursVacation = Int(hours),
           let minuteVacation = Int(minute) {
            setupStartDate(startDate: Date.now.timeIntervalSince1970)
            let minutes = convertToMinutes(hours: hoursVacation, minutes: minuteVacation)
            vacationMinutes = minutes
        }
    }
    
    func convertToMinutes(hours: Int, minutes: Int) -> Int {
        return hours * 60 + minutes
    }
}
