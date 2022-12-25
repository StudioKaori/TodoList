//
//  DueDatePickerView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-25.
//

import SwiftUI

struct DueDatePickerView: View {
  @Binding var showDatePickerSheet: Bool
  @Binding var dueDate: Date
  
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
        showDatePickerSheet.toggle()
      } label: {
        Image(systemName: "x.circle")
          .font(.largeTitle)
      }
    }
    .padding()
  }
}

struct DueDatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DueDatePickerView(showDatePickerSheet: .constant(true), dueDate: .constant(Date()))
  }
}
