//
//  TodoListWidgetEntryView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct TodoListWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
    Text(entry.title)
  }
}
