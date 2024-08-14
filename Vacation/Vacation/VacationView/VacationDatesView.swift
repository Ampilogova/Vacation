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
    let vacationService: VacationService
    @State private var viewModel = VacationDatesViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(vacationService: VacationService) {
        self.vacationService = vacationService
    }
    
    var vacationList: some View {
        List {
            ForEach(viewModel.vacations) { vacation in
                NavigationLink(destination: CreateDestinationView(viewModel: CreateDestinationViewModel(vacation: vacation, vacationService: vacationService))) {
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
            .onDelete(perform: viewModel.deleteVacation)
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
                Text(viewModel.convertToHoursMinutes())
                    .foregroundColor(.gray)
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
                    CreateDestinationView(viewModel: CreateDestinationViewModel(vacation: nil, vacationService: vacationService))
                        .onDisappear {
                            viewModel.updateVacations()
                            print(viewModel.vacations)
                            viewModel.sortVacationList()
                        }
                }
            }
            .onAppear {
                viewModel.upDateData()
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
