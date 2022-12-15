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
  
  @State private var addTodoString: String = ""
  @FocusState private var addFieldFocused: Bool
  
  private func addTodo() {
    guard !addTodoString.isEmpty else { return }
    todoDataManager.addTodo(todoTitle: addTodoString)
    addTodoString = ""
    addFieldFocused = true
  }
  
  var body: some View {
    ZStack {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        TodoListView(vm: vm)
        
        Spacer()
        
        HStack {
          TextField("Add new todo here...", text: $addTodoString)
            .focused($addFieldFocused)
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
        } // END: Hstack AddTask Text field
        .padding()
        
      } // END: Vstack Main container
      .navigationTitle("Todo")
      
      if vm.showingEditSheet && vm.editTargetTodo != nil {
        TodoEditView(vm: vm)
      }
    } // END: Zstack
    .onAppear {
      addFieldFocused = true
    }

  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
