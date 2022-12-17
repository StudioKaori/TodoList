//
//  Provider.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import WidgetKit
import CoreData

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), todos: [.placeholder(1), .placeholder(2), .placeholder(3), .placeholder(4), .placeholder(5)])
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), todos: [.placeholder(1), .placeholder(2), .placeholder(3), .placeholder(4), .placeholder(5)])
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    var entries: [SimpleEntry] = [SimpleEntry(date: Date(), todos: [])]

    TodoDataManager.shared.fetchTodos(incompleteOnly: true)
    TodoDataManager.shared.savedTodos.forEach { todoEntity in
      entries[0].todos.append(TodoModel(title: todoEntity.title ?? "", completed: false))
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
