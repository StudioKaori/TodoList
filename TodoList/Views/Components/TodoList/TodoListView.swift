//
//  TodoListView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import SwiftUI

struct TodoListView: View {
  @EnvironmentObject var vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  
  private func updateTodosOrder(from: IndexSet, to: Int) {
    print("from:\(from) to: \(to)")
    todoDataManager.savedTodos.move(fromOffsets: from, toOffset: to)
    todoDataManager.updateTodosOrder()
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      List {
        Section {
          ForEach(todoDataManager.savedTodos) { entity in
            if !entity.completed {
              TodoListItemView(entity: entity)
            }
          } // END: Foreach
          .onMove(perform: updateTodosOrder)
        }
        
        if vm.showAllTodos {
          Section(header: Text("Completed todos")) {
            ForEach(todoDataManager.savedTodos) { entity in
              if entity.completed {
                TodoListItemView(entity: entity)
              }
            } // END: Foreach
            .onMove(perform: updateTodosOrder)
          }
        }
        
      } // END: list
      .listStyle(InsetGroupedListStyle())
      .padding(.bottom, 60)
      
    }
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView()
  }
}
