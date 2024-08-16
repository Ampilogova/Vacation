//
//  CreateDestinationViewModel.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 8/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class CreateDestinationViewModel {
    
    var vacationService: VacationService
    let vacation: Vacation?
    var destination = ""
    var selectedDates = Set<DateComponents>()
    var shouldDismiss: Bool = false
    
    var actionTitle: String {
        vacation == nil ? "Add" : "Edit"
    }
    
    var isDisabled: Bool {
         destination == "" ? true : false
    }
    
    var availableDaysText: String {
        guard let date = selectedDates.sorted(by: {($0.day ?? 0) < ($1.day ?? 0)}).first else {
            return ""
        }
        
        let days = vacationService.futureBalance(at: date).toDays()
        let balance = days - selectedDates.count
        return "Possibly available days: \(balance)"
    }
    
    init(vacation: Vacation?, vacationService: VacationService) {
        self.vacation = vacation
        self.vacationService = vacationService
    }
    
    
    func saveVacation() {
        if vacation?.destination != nil {
            vacation?.destination = destination
            vacation?.dates = selectedDates
        } else {
            let newVacation = Vacation(destionation: destination, dates: datesWithWeekdays()) //move to service
            vacationService.createVacation(newVacation)
        }
    }
    
    private func datesWithWeekdays() -> Set<DateComponents> {
        let calendar = Calendar.current
        var updatedDates: Set<DateComponents> = []
        
        for dateComponent in selectedDates {
            if let date = calendar.date(from: dateComponent) {
                var newComponent = dateComponent
                newComponent.weekday = calendar.component(.weekday, from: date)
                updatedDates.insert(newComponent)
            }
        }
        return updatedDates
    }
}
