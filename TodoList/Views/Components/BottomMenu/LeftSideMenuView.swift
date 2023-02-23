//
//  LeftSideMenuView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-02-23.
//

import SwiftUI

struct LeftSideMenuView: View {
  @EnvironmentObject var vm: HomeViewModel
  @Binding var isShowingTodoInputField: Bool
  
  var body: some View {
    HStack {
      Spacer()
      
      VStack(alignment: .center) {
        
        // More menu button
        Menu {
          Button {
            vm.showAllTodos.toggle()
          } label: {
            Label(vm.showAllTodos ? "Hide Completed Todos" : "Show All Todos", systemImage: vm.showAllTodos ? "eye.slash" : "eye.fill")
          }
          Button("Item2", action: {})
          Button("Item3", action: {})
        } label: {
          Image(systemName: "ellipsis.circle")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30)
            .foregroundColor(Color.theme.accent)
            .background(Color.theme.background)
            .cornerRadius(50)
            .shadow(radius: 6, x: 3, y: 3)
        }
        .padding(.bottom, 10)
        
        // Add todo button
        Button {
          withAnimation(.easeInOut) {
            self.isShowingTodoInputField.toggle()
          }
        } label: {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .foregroundColor(Color.theme.accent)
            .background(Color.theme.background)
            .cornerRadius(50)
            .shadow(radius: 6, x: 3, y: 3)
        }
      }
    }// END: Hstack
    .padding(.bottom,20)
    .padding(.trailing, 20)
  }
}

struct LeftSideMenuView_Previews: PreviewProvider {
    static var previews: some View {
      LeftSideMenuView(isShowingTodoInputField: .constant(true))
    }
}
