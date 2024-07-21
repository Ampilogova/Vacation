//
//  VacationTime.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/20/24.
//

import Foundation
import SwiftData

struct VacationTime: Codable {
    var hours: Int
    var minutes: Int
    
    init(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
    }
}
