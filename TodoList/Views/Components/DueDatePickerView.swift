//
//  DueDatePickerView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-25.
//

import SwiftUI

struct DueDatePickerView: View {
  @Binding var dueDate: Date
  @Binding var isDueDateDateOnly: Bool
  @Binding var isDueDateReminderOn: Bool
  @Binding var isDueDateActive: Bool
  @Binding var showDatePickerSheet: Bool
  
  private func resetBindingValues() {
    dueDate = Date()
    isDueDateDateOnly = false
    isDueDateReminderOn = false
    isDueDateActive = false
    showDatePickerSheet = false
  }
  
  var body: some View {
    VStack {
      
      List {
        Section(header: Text("Reminder")) {
          Toggle("Set reminder", isOn: $isDueDateReminderOn)
        }
        
        Section(header: Text("Date")) {
          DatePicker(
            "Due Date",
            selection: $dueDate,
            displayedComponents: [.date]
          )
          .datePickerStyle(.graphical)
          
          
          HStack {
            Button {
              isDueDateDateOnly.toggle()
            } label: {
              Text(isDueDateDateOnly ? "Add time" : "Delete time")
            }
            
            if !isDueDateDateOnly {
              Spacer()
              
              DatePicker("Time",
                         selection: $dueDate,
                         displayedComponents: [.hourAndMinute]
              )
              .labelsHidden()
            }
          } // END: Hstack
          
        } // END: Date Section
        
      }
      
      
      
      HStack(spacing: 18) {
        Button {
          showDatePickerSheet = false
        } label: {
          HStack(spacing: 0) {
            Image(systemName: "x.circle")
            Text("Cancel")
          }
        }
        
        Button {
          resetBindingValues()
        } label: {
          HStack(spacing: 0) {
            Image(systemName: "trash.circle")
            Text("Delete")
          }
        }
        
        Button {
          isDueDateActive = true
          showDatePickerSheet = false
        } label: {
          HStack(spacing: 0) {
            Image(systemName: "checkmark.circle")
            Text("Save")
          }
        }
        
      } // END: Fotter Hstack
      .font(.body)
      
    }
  }
}

struct DueDatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DueDatePickerView(dueDate: .constant(Date()),
                      isDueDateDateOnly: .constant(true),
                      isDueDateReminderOn: .constant(false),
                      isDueDateActive: .constant(false),
                      showDatePickerSheet: .constant(true))
  }
}
