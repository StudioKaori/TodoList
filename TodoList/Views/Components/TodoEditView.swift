//
//  TodoEditView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct TodoEditView: View {
  let vm: HomeViewModel
  var todo: TodoEntity
  @Binding var showingEditSheet: Bool
  @State var todoString = ""
  
//  init(vm: HomeViewModel, todo: TodoEntity, editTargetTodo: Binding<TodoEntity>? = nil) {
//    self.vm = vm
//    self.todo = todo
//    self._editTargetTodo = editTargetTodo ?? nil
//    self._todoString = State(initialValue: todo.title ?? "")
//  }
  
  init(vm: HomeViewModel, todo: TodoEntity, showingEditSheet: Binding<Bool>) {
    self.vm = vm
    self.todo = todo
    self._showingEditSheet = showingEditSheet
    self._todoString = State(initialValue: todo.title ?? "")
  }
  
  var body: some View {
    HStack {
      TextField(todo.title ?? "", text: $todoString)
        .onSubmit {
          vm.updateTodo(entity: todo)
          showingEditSheet.toggle()
        }
        .font(.headline)
        .padding(.leading)
        .frame(height: 55)
        .background(Color.theme.textFieldBackground)
        .cornerRadius(10)
      
      Button {
        vm.updateTodo(entity: todo)
        showingEditSheet.toggle()
      } label: {
        Image(systemName: "plus.circle")
          .font(.headline)
          .foregroundColor(Color.theme.primaryText)
      }
    } // END: Hstack AddTask Text field
  }
}

//struct TodoEditView_Previews: PreviewProvider {
//  static var previews: some View {
//    TodoEditView(todo: <#T##TodoEntity#>)
//  }
//}
