//
//  HomeView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject var vm = HomeViewModel()
  @StateObject private var todoDataManager = TodoDataManager.shared
  @FocusState private var addTodoFieldFocus: Bool
  
  @State private var addTodoString: String = ""
  
  private func addTodo() {
    guard !addTodoString.isEmpty else { return }
    todoDataManager.addTodo(todoTitle: addTodoString, incompleteOnly: vm.showAllTodos ? false : true)
    addTodoString = ""
    addTodoFieldFocus = false
  }
  
  var body: some View {
    ZStack {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        Text("Todos")
          .font(.headline)
          .padding()
        
        TodoListView(vm: vm)
        
        Spacer()
        
        HStack {
          TextField("Add new todo here...", text: $addTodoString)
            .focused($addTodoFieldFocus)
            .onSubmit {
              addTodo()
            }
            .font(.system(size: UserSettings.fontSize.body))
            .padding(.leading)
            .frame(height: 55)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(10)
          
          Button {
            addTodo()
          } label: {
            Image(systemName: "plus.circle")
              .font(.system(size: UserSettings.fontSize.largeTitle))
              .foregroundColor(Color.theme.accent)
          }
          
          if addTodoFieldFocus {
            Button {
              addTodoFieldFocus = false
            } label: {
              Image(systemName: "arrow.down.circle")
                .font(.system(size: UserSettings.fontSize.largeTitle))
                .foregroundColor(Color.theme.secondaryText)
            }
          }
        } // END: Hstack AddTask Text field
        .padding()
        
      } // END: Vstack Main container
      
      if vm.showingEditSheet && vm.editTargetTodo != nil {
        TodoEditView(vm: vm, ieEditMode: true)
      }
    } // END: Zstack
    .onAppear {
      addTodoFieldFocus = false
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
