//
//  VacationApp.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI
import SwiftData

@main
struct VacationApp: App {
    
    private var vacationService: VacationService
    
    init() {
        vacationService = VacationServiceImpl()
    }
    
    var body: some Scene {
        WindowGroup {
            VacationDatesView(vacationService: vacationService)
        }
        .modelContainer(ModelContainer.shared)
    }
}

