//
//  AddTodoView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-02-21.
//

import SwiftUI

struct AddTodoView: View {
  @Binding var isShowingTodoInputField: Bool

  func dismiss() {
    self.isShowingTodoInputField = false
  }
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.7)
        .onTapGesture {
          isShowingTodoInputField.toggle()
        }
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        TodoInputFieldsView(isEditMode: false, submitHandler: dismiss)
          .background(Color.theme.background)
      }
    }
  }
}

struct AddTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddTodoView(isShowingTodoInputField: .constant(true))
  }
}
