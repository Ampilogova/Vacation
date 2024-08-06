//
//  VacationTime.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import Foundation
import SwiftData

// Move to dedicated folder like Vacation/Models

struct VacationTime: Codable {
    var minutes: Double // maybe use Int
    
    init(minutes: Double) {
        self.minutes = minutes
    }
}
