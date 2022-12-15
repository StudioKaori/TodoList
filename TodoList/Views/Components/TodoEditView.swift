//
//  TodoEditView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct TodoEditView: View {
  let vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  @State private var todoString = ""
  
  init(vm: HomeViewModel) {
    self.vm = vm
    self._todoString = State(initialValue: vm.editTargetTodo?.title ?? "")
  }
  
  private func updateTodo() {
    if todoString.isEmpty { return }
    if vm.editTargetTodo == nil { return }
    vm.editTargetTodo?.title = todoString
    todoDataManager.saveData()
    vm.showingEditSheet.toggle()
  }
  
  var body: some View {
    HStack {
      TextField(vm.editTargetTodo?.title ?? "", text: $todoString)
        .onSubmit {
          updateTodo()
        }
        .font(.headline)
        .padding(.leading)
        .frame(height: 55)
        .background(Color.theme.textFieldBackground)
        .cornerRadius(10)
      
      Button {
        updateTodo()
      } label: {
        Image(systemName: "plus.circle")
          .font(.headline)
          .foregroundColor(Color.theme.secondaryText)
      }
    } // END: Hstack AddTask Text field
  }
}

//struct TodoEditView_Previews: PreviewProvider {
//  static var previews: some View {
//    TodoEditView(todo: <#T##TodoEntity#>)
//  }
//}
