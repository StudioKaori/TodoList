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
            Image(systemName: "circle")
              .foregroundColor(Color.theme.secondaryText)
              .onTapGesture {
                withAnimation{
                  TodoDataManager.shared.tickTodo(entity: entity)
                }
              }
            
            Text(entity.title ?? "")
          }
          .font(.system(size: UserSettings.fontSize.body))
          .swipeActions(edge: .trailing) {
            Button {
              withAnimation {
                todoDataManager.tickTodo(entity: entity)
              }
            } label: {
              Image(systemName: "checkmark.circle.fill")
            }
            .tint(Color.theme.accent)
          }
          .swipeActions(edge: .leading) {
            Button {
              withAnimation {
                vm.showTodoEdit(entity: entity)
              }
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
      
      HStack {
        Spacer()
        
        Button {
          //
        } label: {
          HStack {
            Image(systemName: "checkmark.circle.fill")
            Text("Show All Todos")
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
