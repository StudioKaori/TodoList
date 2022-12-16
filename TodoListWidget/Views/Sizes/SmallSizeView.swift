//
//  SmallSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI
import WidgetKit

struct SmallSizeView: View {
  var entry: SimpleEntry
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.theme.background
      
      VStack(alignment: .leading) {
        WidgetTitleView()
        
        WidgetTodoListView(entry: entry, maxTodoLength: 4)
      }
    } // END: Vstack main container
  }
}

struct SmallSizeView_Previews: PreviewProvider {
  static var previews: some View {
    SmallSizeView(entry: .placeholder())
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
