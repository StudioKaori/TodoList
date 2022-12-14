//
//  HomeView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject var vm = HomeViewModel()
  @State var addTodoString: String = ""
  
  private func addTodo() {
    guard !addTodoString.isEmpty else { return }
    vm.addTodo(todoTitle: addTodoString)
    addTodoString = ""
  }
  
  var body: some View {
    ZStack {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        List {
          ForEach(vm.savedTodos) { entity in
            Text(entity.title ?? "")
              .onTapGesture {
                vm.updateTodo(entity: entity)
              }
          }
          .onDelete(perform: vm.deleteTodo)
        }
        .listStyle(PlainListStyle())
        
        Spacer()
        
        HStack {
          TextField("Add todo here...", text: $addTodoString)
            .onSubmit {
              addTodo()
            }
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(10)
          
          Button {
            addTodo()
          } label: {
            Image(systemName: "plus.circle")
              .font(.headline)
              .foregroundColor(Color.theme.primaryText)
          }
        } // END: Hstack AddTask Text field
        
      } // END: Vstack Main container
      .padding(.horizontal)
      .navigationTitle("Todo")
    } // END: Zstack
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
