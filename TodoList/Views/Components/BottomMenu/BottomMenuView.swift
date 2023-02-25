//
//  BottomMenuView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-02-22.
//

import SwiftUI

struct BottomMenuView: View {
  @EnvironmentObject var vm: HomeViewModel
  @Binding var isShowingTodoInputField: Bool
  
  var body: some View {
    
    ZStack {
      VStack(spacing: 0) {
        ZStack {
          // BG
          Color.theme.accent.opacity(0.3)
            .overlay() {
              ZStack(alignment: .top) {
                Rectangle()
                  .frame(height: 30)
                Circle()
                  .frame(height: 60)
              }
              .blendMode(.destinationOut)
            }
            .frame(height: 60)
            .compositingGroup()
          
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
              .cornerRadius(60)
              .shadow(radius: 6, x: 3, y: 3)
          }
        }
        
        Color.theme.accent.opacity(0.3)
          .frame(height: 30)
        
      }
      .frame(height: 90)
      
      HStack {
        Spacer()
        
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
          Image(systemName: "ellipsis")
            .font(.system(size: 24))
            .foregroundColor(Color.theme.accent)

        }
      }
      .padding(30)
      
    }
    .frame(height: 90)
    
    
  }
}

struct BottomMenuView_Previews: PreviewProvider {
  static var previews: some View {
    BottomMenuView(isShowingTodoInputField: .constant(true))
  }
}
