//
//  WidgetTitleView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-16.
//

import SwiftUI
import WidgetKit

struct WidgetTitleView: View {
  var body: some View {
    HStack {
      Text("Todos")
        .bold()
        .padding(.top, 10)
        .padding(.bottom, 6)
        .padding(.horizontal)
      
      Spacer()
      
      Image(systemName: "plus")
        .padding(.horizontal)
    }
    .font(.system(size: UserSettings.fontSize.body))
    .foregroundColor(Color.theme.accent)
    .frame(maxWidth: .infinity)
    .background(Color.theme.textFieldBackground)
  }
}

struct WidgetTitleView_Previews: PreviewProvider {
  static var previews: some View {
    WidgetTitleView()
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
