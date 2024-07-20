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
    var destionation: String
    var days: Int
    
    init(id: UUID = UUID(), destionation: String, days: Int) {
        self.id = id
        self.destionation = destionation
        self.days = days
    }
}

