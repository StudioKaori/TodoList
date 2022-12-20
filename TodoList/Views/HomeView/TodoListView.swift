//
//  TodoListView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import SwiftUI

struct TodoListView: View {
  @StateObject var vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      List {
        ForEach(todoDataManager.savedTodos) { entity in
          if !entity.completed || vm.showAllTodos {
            TodoListItemView(vm: vm, entity: entity)
          }
        } // END: Foreach
        .onMove(perform: vm.move)
      } // END: list
      
      HStack {
        Spacer()
        
        Button {
          vm.showAllTodos.toggle()
//          if vm.showAllTodos {
//            todoDataManager.fetchTodos(activeListId: todoDataManager.userSettings?.activeListId ?? defaultActiveListId)
//          } else {
//            todoDataManager.fetchTodos(activeListId: todoDataManager.userSettings?.activeListId ?? defaultActiveListId)
//          }
        } label: {
          HStack {
            Image(systemName: vm.showAllTodos ? "eye.slash" : "eye.fill")
            Text(vm.showAllTodos ? "Hide Completed Todos" : "Show All Todos")
          }
          .font(.caption)
        }
      }
      .padding(.horizontal, 24)
      .padding(.vertical,12)
      .background(Color.theme.listBackground)
      
    }
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView(vm: HomeViewModel())
  }
}
