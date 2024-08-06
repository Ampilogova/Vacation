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
    var body: some Scene {
        WindowGroup {
            VacationDatesView()
        }
        .modelContainer(ModelContainer.shared)
    }
}

// Move to separate file
extension ModelContainer {
    // Maybe rename to "default"
    static let shared: ModelContainer = {
        let schema = Schema([
            Vacation.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
