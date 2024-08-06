//
//  Vacation.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import UIKit
import SwiftData

// Move to dedicated folder like Vacation/Models

@Model
class Vacation: ObservableObject, Identifiable {
    var id = UUID()
    var destination: String
    
    // maybe create new @Model class VacationDate, and here use var dates: [VacationDate]. You will still need Set<DateComponents>, but it can be created in CreateDestinationViewModel
    var dates: Set<DateComponents>
    
    // added default parameters to provide a way to create an empty object for create flow
    init(id: UUID = UUID(), destionation: String = "", dates: Set<DateComponents> = Set<DateComponents>()) {
        self.id = id
        self.destination = destionation
        self.dates = dates
    }
}

