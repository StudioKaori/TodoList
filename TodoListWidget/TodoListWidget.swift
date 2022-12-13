//
//  TodoListWidget.swift
//  TodoListWidget
//
//  Created by Kaori Persson on 2022-12-13.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), title: "My todo")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), title: "My todo")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, title: "Test")
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let title: String
}

struct TodoListWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
    Text(entry.title)
  }
}

struct TodoListWidget: Widget {
  let kind: String = "TodoListWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      TodoListWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct TodoListWidget_Previews: PreviewProvider {
  static var previews: some View {
    TodoListWidgetEntryView(entry: SimpleEntry(date: Date(), title: "My todo"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
