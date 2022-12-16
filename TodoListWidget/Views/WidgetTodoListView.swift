//
//  WidgetTodoListView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-16.
//

import SwiftUI

struct WidgetTodoListView: View {
  var entry: SimpleEntry
  var maxTodoLength: Int
  private let todosLength: Int
  
  init(entry: SimpleEntry, maxTodoLength: Int) {
    self.entry = entry
    self.maxTodoLength = maxTodoLength
    self.todosLength = min(entry.todos.count, maxTodoLength)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      ForEach(0 ..< todosLength) { i in
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Image(systemName: "circle.fill")
              .font(.system(size: UserSettings.fontSize.bulletSymbol))
              .foregroundColor(Color.theme.accent)
            
            Text(entry.todos[i].title)
              .foregroundColor(Color.theme.primaryText)
              .font(.system(size: UserSettings.fontSize.widgetBody))
          }
          
          if i != (todosLength - 1) {
            Divider()
          }
        }
      } // END: foreach
    }
    .padding(.horizontal)
    .padding(.vertical, 0)
  }
}

struct WidgetTodoListView_Previews: PreviewProvider {
  static var previews: some View {
    WidgetTodoListView(entry: .placeholder(), maxTodoLength: 4)
  }
}
