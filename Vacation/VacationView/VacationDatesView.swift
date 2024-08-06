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
    @State private var viewModel = VacationDatesViewModel() // pass view model as init parameter
    @Environment(\.dismiss) private var dismiss
    
    // usually ar body comes first
    
    var vacationList: some View { // private
        List {
            ForEach(viewModel.vacations) { vacation in
                NavigationLink(destination: CreateDestinationView(vacation: vacation)) {
                    // Maybe in the future move this to separate view which will be initialized with Vacation.
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vacation.destination)
                                .font(Font.headline.bold())
                            
                            // maybe instead of viewModel.convertDateComponents you can create computed property in Vacation object, something like "var datesTitle: String". Then here you will be able just do "Text(vacation.datesTitle)"
                            Text(viewModel.convertDateComponents(dates: vacation.dates)).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(String(viewModel.countWorkingDays(dates: vacation.dates)) + " days")
                    }
                }
            }
            .onDelete(perform: viewModel.delete) // viewModel.deleteVacation
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
                Text("Current balance: \(viewModel.totalVacationDays()) days") // it's better to provide preapared label from view model, it would look like Text(viewModel.currentBalance". Same below
                Text("Balance after planned vacation: \(viewModel.vacationBalance) days")
                vacationList
            }
            .onChange(of: viewModel.vacations) { // can we call internally in the view model?
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
                // can we do this on the view model init. If not move all this call to viewModel.updateData()
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
                Button("Add", action: viewModel.submit) // viewModel.submitVTO
            }
        }
    }
}
