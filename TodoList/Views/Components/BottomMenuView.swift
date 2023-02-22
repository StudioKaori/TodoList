//
//  BottomMenuView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-02-22.
//

import SwiftUI

struct BottomMenuView: View {
  @Binding var isShowingTodoInputField: Bool
  
  var body: some View {
    HStack {
      Spacer()
      
      VStack(alignment: .center) {
        Button {
          withAnimation(.easeInOut) {
            //
          }
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

struct BottomMenuView_Previews: PreviewProvider {
  static var previews: some View {
    BottomMenuView(isShowingTodoInputField: .constant(true))
  }
}
