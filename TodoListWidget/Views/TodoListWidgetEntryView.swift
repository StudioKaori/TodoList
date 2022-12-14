//
//  TodoListWidgetEntryView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct TodoListWidgetEntryView : View {
  
  @Environment(\.widgetFamily) var widgetFamily
  
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      SmallSizeView(entry: entry)
    case .systemMedium:
      MediumSizeView(entry: entry)
    case .systemLarge:
      LargeSizeView(entry: entry)
    default:
      Text(entry.date, style: .time)
      Text(entry.todos.first?.title ?? "No Todos")
    }
  }
}
