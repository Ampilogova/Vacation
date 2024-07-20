//
//  VacationApp.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI

@main
struct VacationApp: App {
    var body: some Scene {
        WindowGroup {
            VacationDatesView()
                .modelContainer(for: Vacation.self)
        }
    }
}
