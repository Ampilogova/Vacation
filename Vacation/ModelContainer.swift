//
//  ModelContainer.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 8/12/24.
//

import Foundation
import SwiftData

extension ModelContainer {
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
