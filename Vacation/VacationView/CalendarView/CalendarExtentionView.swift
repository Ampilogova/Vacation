//
//  CalendarView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI

struct CalendarExtentionView: View {
    let monthWithDates: (month: String, dates: [Date])
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            let firstDayOfMonth = calendar.component(.weekday, from: monthWithDates.dates.first!)
            let leadingSpaces = firstDayOfMonth - 1
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<leadingSpaces, id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity)
                }
                
                ForEach(monthWithDates.dates, id: \.self) { date in
                    Text("\(calendar.component(.day, from: date))")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
