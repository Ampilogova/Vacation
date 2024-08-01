//
//  VacationDatesView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI
import SwiftData

@MainActor
struct VacationDatesView: View {
    @State private var viewModel = VacationDatesViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var vacationList: some View {
        List {
            ForEach(viewModel.vacations) { vacation in
                NavigationLink(destination: CreateDestinationView(vacation: vacation)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vacation.destination)
                                .font(Font.headline.bold())
                            Text(viewModel.convertDateComponents(dates: vacation.dates)).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(String(viewModel.countWorkingDays(dates: vacation.dates)) + " days")
                    }
                }
            }
            .onDelete(perform: viewModel.delete)
        }
    }
    
    @ViewBuilder var trailngItemas: some View {
        HStack {
            Button(action: {
                viewModel.showCreateVacation = true
            }, label: {
                Image(systemName: "plus")
            })
            Button(action: {
                viewModel.showCreateSettings = true
            }, label: {
                Image(systemName: "gear")
            })
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Current balance: \(viewModel.totalVacationDays()) days")
                Text("Balance after planned vacation: \(viewModel.vacationBalance) days")
                vacationList
            }
            .onChange(of: viewModel.vacations) {
                viewModel.vacationBalance = viewModel.balanceVacationDates()
            }
            .navigationBarItems(leading: Button("Add VTO") {
                viewModel.showAlert.toggle()
            }, trailing:
                trailngItemas
            )
            .popover(isPresented: $viewModel.showCreateSettings) {
                SettingsView()
            }
            .popover(isPresented:  $viewModel.showCreateVacation) {
                NavigationView {
                    CreateDestinationView()
                        .onDisappear {
                            viewModel.fetchData()
                            viewModel.sortVacationList()
                        }
                }
            }
            .onAppear {
                viewModel.addVacationHours()
                viewModel.updateVacationMinutes()
                viewModel.vacationBalance = viewModel.balanceVacationDates()
                viewModel.sortVacationList()
            }
            
            .background(.bar)
            .alert("Enter hours", isPresented: $viewModel.showAlert) {
                TextField("Minutes", text: $viewModel.vto)
                Button("Cancel", action:  {
                    dismiss()
                })
                Button("Add", action: viewModel.submit)
            }
        }
    }
}
