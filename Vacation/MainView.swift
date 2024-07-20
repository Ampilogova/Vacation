//
//  MainView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            VacationDatesView()
                .tabItem {
                    Label("Vacation", systemImage: "airplane.departure")
                }
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
            }
        }
    }
}
