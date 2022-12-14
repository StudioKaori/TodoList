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
    SimpleEntry(date: Date(), title: "My todo")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), title: "My todo")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    var entries: [SimpleEntry] = []
    var savedTodos: [TodoEntity] = []
    print("--get time line")
    
    let persistenceController = PersistenceController.shared
    
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    
    do {
      savedTodos = try persistenceController.container.viewContext.fetch(request)
      print("savedTodos: \(savedTodos)")
      
      // Generate a timeline consisting of five entries an hour apart, starting from the current date.
      let currentDate = Date()
      for hourOffset in 0 ..< 5 {
        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, title: savedTodos.first?.title ?? "No data: \(savedTodos.count)")
        entries.append(entry)
      }
    } catch let error {
      print("Error fetching: \(error)")
      
      // delete later
      let currentDate = Date()
      for hourOffset in 0 ..< 5 {
        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, title: "Error fetching: \(error)")
        entries.append(entry)
      } // END: delete later
    }
    
    print("entries: \(entries)")
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
