//
//  ContentView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI

struct CalendarView: View {
    
    @State private var date = Date()
    let dateRange: ClosedRange<Date>? = {
        let calendar = Calendar.current
        let startComponent = DateComponents(year: 2024, month: 1, day: 1)
        let endComponent = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        if let startDate = calendar.date(from: startComponent), let endDate = calendar.date(from: endComponent) {
            return startDate...endDate
        } else {
            return nil
        }
    }()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(generateCalendar(), id: \.month) { month in
                    VStack(alignment: .leading) {
                        Text(month.month)
                            .font(.title3)
                            .bold()
                        CalendarExtentionView(monthWithDates: month)
                            .font(.system(size: 12))
                    }
                    .padding()
                }
            }
        }
    }
    
    private func generateCalendar() -> [(month: String, dates: [Date])] {
        guard let dateRange = dateRange else { return [] }
        let calendar = Calendar.current
        var monthsWithDates: [(month: String, dates: [Date])] = []
        
        var currentDate = dateRange.lowerBound
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        while currentDate <= dateRange.upperBound {
            let monthString = dateFormatter.string(from: currentDate)
            
            var dates: [Date] = []
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
            let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
            
            for day in range {
                if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                    dates.append(date)
                }
            }
            
            monthsWithDates.append((month: monthString, dates: dates))
            
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
                currentDate = nextMonth
            } else {
                break
            }
        }
        return monthsWithDates
    }
}
