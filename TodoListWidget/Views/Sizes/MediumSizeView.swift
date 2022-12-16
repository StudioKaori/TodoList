//
//  MediumSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI
import WidgetKit

struct MediumSizeView: View {
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

struct MediumSizeView_Previews: PreviewProvider {
    static var previews: some View {
      MediumSizeView(entry: .placeholder())
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
