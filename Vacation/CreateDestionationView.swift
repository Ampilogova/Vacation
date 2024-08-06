//
//  CreateDestionationView.swift
//  Vacation
//
//  Created by Tatiana Ampilogova on 7/19/24.
//

// Move to dedicated folder like Vacation/UI/CreateDestination
import SwiftUI

@MainActor
struct CreateDestinationView: View {
    // it's better to pass viewModel to init. This way you can write tests with fake view model.
    var viewModel = VacationDatesViewModel() // this view should have separate view model. Shared logic from VacationDatesViewModel should be extracted to separate class and be reused from VacationDatesViewModel and CreateDestinationViewModel
    
    // I think you can make "var vacation" as @State and remove dates and destination. Also vacation likely should go to CreateDestinationViewModel
    var vacation: Vacation?
    @State private var isDisabled = true // unused ?
    @State private var isSheetPresented = false // unused ?
    @State private var destination = ""
    @State private var dates: Set<DateComponents> = []
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    // ^ add private where needed for properties
    
    private var editorTitle: String { // this also can go to the view model
        vacation == nil ? "Add" : "Edit"
    }
    
    init(vacation: Vacation? = nil) {
        self.vacation = vacation
        if let vacation = vacation {
            _destination = State(initialValue: vacation.destination)
            _dates = State(initialValue: vacation.dates)
        } // I think in the else case you can do self.vacation = Vacation() this will make "self.vacation" non optional
    }
    
    // Unused?
    let dateRange: ClosedRange<Date>? = { // this can go to view model
        let calendar = Calendar.current
        // likely need to make this dynamic something like 1 year from current date
        let startComponent = DateComponents(year: 2024, month: 1, day: 1, weekday: 2)
        let endComponent = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59, weekday: 3)
        if let startDate = calendar.date(from: startComponent), let endDate = calendar.date(from: endComponent) {
            return startDate...endDate
        } else {
            return nil
        }
    }()
    
    var body: some View {
        ScrollView {
            VStack {
                if let dateComponent = dates.first, // some of logic in this dive can go to view model as well
                   let date = Calendar.current.date(from: dateComponent) {
                    Text("Possibly available days: \(viewModel.checkAvailability(futureDay: date))")
                        .font(.headline)
                }
                Spacer()
                TextField("Destination", text: $destination)
                    .textFieldStyle(.roundedBorder)
                MultiDatePicker("Dates Available", selection: $dates)
                    .frame(height: 500)
            }
            .padding()
            .navigationBarItems(trailing: Button(action: saveVacation, label: {
                Text(editorTitle) //  maybe rename to actionTitle. I'm using chat GPT to find good names
            }))
        }
        .bold() // do we need this on the whole view?
    }
    
    private func saveVacation() { // maybe move this method to view model as well
         if let existingVacation = vacation {
             existingVacation.destination = destination
             existingVacation.dates = dates
         } else {
             let newVacation = Vacation(destionation: destination, dates: datesWithWeekdays())
             modelContext.insert(newVacation)
         }
         dismiss()
     }

    // This is interesting problem that that DateComponents from the calendar doesn't have weekday parameter. It is also annoying that DateComponents properties all optional. I would consider to create new object VacationDate with day, month, year, weekday properties. And store them in as array in vacation (I added coment in Vacation)
    // Move this logic to the view model
    private func datesWithWeekdays() -> Set<DateComponents> {
        let calendar = Calendar.current
        var updatedDates: Set<DateComponents> = []
        
        for dateComponent in dates {
            if let date = calendar.date(from: dateComponent) {
                var newComponent = dateComponent
                newComponent.weekday = calendar.component(.weekday, from: date)
                updatedDates.insert(newComponent)
            }
        }
        return updatedDates
    }
}

