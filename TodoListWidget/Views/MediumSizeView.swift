//
//  MediumSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct MediumSizeView: View {
  var entry: SimpleEntry
  
  var body: some View {
    
    ZStack {
      Color.theme.background
      
      VStack(alignment: .leading) {
        Text("Todos")
          .bold()
          .font(.system(size: UserSettings.fontSize.h3))
          .foregroundColor(Color.theme.accent)
          .frame(maxWidth: .infinity)
          .frame(height: 28)
          .background(Color.theme.textFieldBackground)

        VStack(alignment: .leading, spacing: 6) {
          ForEach(entry.todos.prefix(4)) { todo in
            Text(todo.title)
              .foregroundColor(Color.theme.primaryText)
              .font(.system(size: UserSettings.fontSize.body))
          }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        
      }
    } // END: Vstack main container
  }
}

struct MediumSizeView_Previews: PreviewProvider {
    static var previews: some View {
      MediumSizeView(entry: .placeholder())
    }
}
