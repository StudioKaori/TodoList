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
  
  var body: some View {
    ZStack {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        HStack {
          TextField("Add todo here...", text: $addTodoString)
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(10)
          
          Button {
            guard !addTodoString.isEmpty else { return }
            vm.addTodo(todoTitle: addTodoString)
            addTodoString = ""
          } label: {
            Image(systemName: "plus.circle")
              .font(.headline)
              .foregroundColor(Color.theme.primaryText)
          }

        }
      } // END: Vstack
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
