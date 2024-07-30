//
//  VacationTime.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import Foundation
import SwiftData

struct VacationTime: Codable {
    var minutes: Double
    
    init(minutes: Double) {
        self.minutes = minutes
    }
}
