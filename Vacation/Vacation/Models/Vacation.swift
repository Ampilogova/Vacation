//
//  Vacation.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import UIKit
import SwiftData

@Model
class Vacation: ObservableObject, Identifiable {
    var id = UUID()
    var destination: String
    var dates: Set<DateComponents>
    
    init(id: UUID = UUID(), destionation: String, dates: Set<DateComponents>) {
        self.id = id
        self.destination = destionation
        self.dates = dates
    }
}

