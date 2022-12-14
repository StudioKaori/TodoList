//
//  LargeSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct LargeSizeView: View {
  var entry: SimpleEntry
  
  var body: some View {
    Text(entry.date, style: .time)
    Text(entry.todos.first?.title ?? "No data")
  }
}

//struct LargeSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        LargeSizeView()
//    }
//}
