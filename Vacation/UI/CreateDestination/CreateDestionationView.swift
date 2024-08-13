//
//  CreateDestionationView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

import SwiftUI

@MainActor
struct CreateDestinationView: View {
    
    @State var viewModel: CreateDestinationViewModel
    
    init(viewModel: CreateDestinationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.availableDaysText).font(.headline)
                Spacer()
                TextField("Destination", text: $viewModel.destination)
                    .textFieldStyle(.roundedBorder)
                MultiDatePicker("Dates Available", selection: $viewModel.selectedDates)
                    .frame(height: 500)
            }
            .padding()
            .navigationBarItems(trailing: Button(action: {
                viewModel.saveVacation()
            }, label: {
                Text(viewModel.actionTitle)
            })
                .disabled(viewModel.isDisabled))
        }
        .bold()
    }
}

