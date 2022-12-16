//
//  LargeSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI
import WidgetKit

struct LargeSizeView: View {
  var entry: SimpleEntry
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.theme.background
      
      VStack(alignment: .leading) {
        HStack {
          Text("Todos")
            .bold()
            .font(.system(size: UserSettings.fontSize.body))
            .foregroundColor(Color.theme.accent)
            .padding()

          Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 36)
        .background(Color.theme.textFieldBackground)
        
        WidgetTodoListView(entry: entry, maxTodoLength: 20)
      }
    } // END: Vstack main container
  }
}

struct LargeSizeView_Previews: PreviewProvider {
    static var previews: some View {
      LargeSizeView(entry: .placeholder())
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
