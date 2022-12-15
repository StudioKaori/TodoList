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
        HStack {
          Text(entity.title ?? "")
          Spacer()
          Image(systemName: "checkmark.circle")
            .foregroundColor(Color.theme.secondaryText)
            .onTapGesture {
              TodoDataManager.shared.tickTodo(entity: entity)
            }
        }
        .font(.system(size: UserSettings.fontSize.body))
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
            vm.showTodoEdit(entity: entity)
          } label: {
            Image(systemName: "pencil")
          }
          .tint(.orange)
        }
        .onTapGesture {
          vm.showTodoEdit(entity: entity)
        }
        // END: Hstack list item
        
      }
    } // END: list
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView(vm: HomeViewModel())
  }
}
