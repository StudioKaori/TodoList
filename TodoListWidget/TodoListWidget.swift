//
//  TodoListWidget.swift
//  TodoListWidget
//
//  Created by Kaori Persson on 2022-12-13.
//

import WidgetKit
import SwiftUI
import CoreData

struct TodoListWidget: Widget {
  let kind: String = "TodoListWidget"
  
  let persistenceController = PersistenceController.shared
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      TodoListWidgetEntryView(entry: entry)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
    .configurationDisplayName("Todo List")
    .description("This is an example widget.")
  }
}

struct TodoListWidget_Previews: PreviewProvider {
  static var previews: some View {
    TodoListWidgetEntryView(entry: SimpleEntry(date: Date(), title: "My todo"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
