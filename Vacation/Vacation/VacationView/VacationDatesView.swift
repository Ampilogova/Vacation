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
    static var vacationService: VacationService = VacationServiceImpl()
    @State private var viewModel = VacationDatesViewModel(vacationService: vacationService)
    @Environment(\.dismiss) private var dismiss
    
    init(vacationService: VacationService) {
        self._viewModel = State(initialValue: VacationDatesViewModel(vacationService: Self.vacationService))
    }
    
    var vacationList: some View {
        List {
            ForEach(viewModel.vacations) { vacation in
                NavigationLink(destination: CreateDestinationView(viewModel: CreateDestinationViewModel(vacation: vacation, vacationService: VacationDatesView.vacationService))) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vacation.destination)
                                .font(Font.headline.bold())
                            Text(viewModel.vacationDates).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(viewModel.workingDays)
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
                Text(viewModel.balanceTitle)
                Text(viewModel.balanceVacationDates)
                vacationList
                Text(viewModel.convertToHoursMinutes())
                    .foregroundColor(.gray)
            }
            .onChange(of: viewModel.vacations) {
                viewModel.upDateData()
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
                    CreateDestinationView(viewModel: CreateDestinationViewModel(vacation: nil, vacationService: VacationDatesView.vacationService))
                        .onDisappear {
                            viewModel.upDateData()
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
                Button("Add", action: viewModel.submitVTO)
            }
        }
    }
}
