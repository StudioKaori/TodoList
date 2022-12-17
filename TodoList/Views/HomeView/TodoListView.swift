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
    ZStack(alignment: .topLeading) {
      List {
        ForEach(todoDataManager.savedTodos) { entity in
          HStack {
            Image(systemName: entity.completed ? "checkmark.circle" : "circle")
              .foregroundColor(entity.completed ? Color.theme.accent : Color.theme.secondaryText)
              .onTapGesture {
                withAnimation{
                  TodoDataManager.shared.updateCompleted(entity: entity, completed: !entity.completed, incompleteOnly: vm.showAllTodos ? false : true)
                }
              }
            
            Text(entity.title ?? "")
              .strikethrough(entity.completed ? true : false)
          }
          .font(.system(size: UserSettings.fontSize.body))
          .swipeActions(edge: .trailing) {
            Button {
              withAnimation {
                todoDataManager.updateCompleted(entity: entity, completed: !entity.completed, incompleteOnly: vm.showAllTodos ? false : true)
              }
            } label: {
              Image(systemName: entity.completed ? "circle" : "checkmark.circle.fill")
            }
            .tint(Color.theme.accent)
          }
          .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
              withAnimation {
                todoDataManager.deleteTodo(entity: entity, incompleteOnly: vm.showAllTodos ? false : true)
              }
            } label: {
              Image(systemName: "trash")
            }
            .tint(.red)
            
            Button {
              withAnimation {
                vm.showTodoEdit(entity: entity)
              }
            } label: {
              Image(systemName: "pencil")
            }
            .tint(.blue)
          }
          .onTapGesture {
            vm.showTodoEdit(entity: entity)
          }
          // END: Hstack list item
        }
      } // END: list
      
      HStack {
        Spacer()
        
        Button {
          vm.showAllTodos.toggle()
          if vm.showAllTodos {
            todoDataManager.fetchTodos(incompleteOnly: false)
          } else {
            todoDataManager.fetchTodos(incompleteOnly: true)
          }
        } label: {
          HStack {
            Image(systemName: vm.showAllTodos ? "eye.slash" : "eye.fill")
            Text(vm.showAllTodos ? "Hide Completed Todos" : "Show All Todos")
          }
          .font(.caption)
        }
      }
      .padding(.horizontal, 24)
      .padding(.vertical,8)
      .background(Color.theme.listBackground)
      
    }
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView(vm: HomeViewModel())
  }
}
