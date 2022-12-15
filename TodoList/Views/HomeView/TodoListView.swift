//
//  TodoListView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import SwiftUI

struct TodoListView: View {
  let vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  
  var body: some View {
    List {
      ForEach(todoDataManager.savedTodos) { entity in
        Text(entity.title ?? "")
          .swipeActions(edge: .trailing) {
            Button {
              todoDataManager.tickTodo(entity: entity)
            } label: {
              Image(systemName: "checkmark.circle.fill")
            }
            .tint(Color.theme.accent)
          }
          .swipeActions(edge: .leading) {
            Button {
              vm.editTargetTodo = entity
              vm.showingEditSheet.toggle()
            } label: {
              Image(systemName: "pencil")
            }
            .tint(.orange)
          }
          .onTapGesture {
            todoDataManager.updateTodo(entity: entity)
          }
      }
    } // END: list
  }
}

//struct TodoListView_Previews: PreviewProvider {
//  static var previews: some View {
//    TodoListView(editTargetTodo: <#Binding<TodoEntity>#>, showingEditSheet: .constant(true))
//  }
//}
