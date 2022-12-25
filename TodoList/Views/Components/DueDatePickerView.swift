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
  
  var body: some View {
    VStack {
      
      DatePicker(
        "Due Date",
        selection: $dueDate,
        displayedComponents: [.date]
      )
      .datePickerStyle(.graphical)
      
      DatePicker("Time",
                 selection: $dueDate,
                 displayedComponents: [.hourAndMinute]
      )
      
      Button {
        isDueDateActive = true
        showDatePickerSheet = false
      } label: {
        HStack {
          Image(systemName: "x.circle")
            .font(.largeTitle)
          Text("Save")
        }
      }
    }
    .padding()
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
