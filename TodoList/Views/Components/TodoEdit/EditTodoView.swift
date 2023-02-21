//
//  EditTodoView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-02-14.
//

import SwiftUI

struct EditTodoView: View {
  @EnvironmentObject var vm: HomeViewModel
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.7)
        .onTapGesture {
          vm.showingEditSheet.toggle()
        }
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        TodoInputFieldsView(isEditMode: true, todoEntity: vm.editTargetTodo)
          .background(Color.theme.background)
      }
      
    }
  }
}

struct EditTodoView_Previews: PreviewProvider {
  static var previews: some View {
    EditTodoView()
  }
}
