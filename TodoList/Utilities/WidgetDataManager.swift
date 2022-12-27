//
//  TodoImageManager.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-22.
//

import SwiftUI
import CoreData
import WidgetKit

class WidgetDataManager: ObservableObject {
  
  static let shared = WidgetDataManager()
  var widgetListId: String
  
  private init(widgetListId: String = DefaultValues.defaultWidgetListId) {
    self.widgetListId = widgetListId
  }
  
  let container: NSPersistentContainer = PersistenceController.shared.container
  
  func fetchTodosForWidget() -> [TodoModel] {
    var todos: [TodoModel] = []
    
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    let listIdPredicate = NSPredicate(format: "listId = %@", widgetListId)
    let sort = NSSortDescriptor(key: #keyPath(TodoEntity.order), ascending: false)
    request.sortDescriptors = [sort]
    var predicates: [NSPredicate] = [listIdPredicate]
    let incompletePredicate = NSPredicate(format: "completed == %d", false)
    predicates.append(incompletePredicate)
    
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    
    do {
      let results = try container.viewContext.fetch(request)
      results.forEach { todoEntity in
        todos.append(TodoModel(
          title: todoEntity.title ?? "",
          completed: false,
          isDueDateActive: todoEntity.isDueDateActive,
          dueDate: todoEntity.dueDate,
          isDueDateDateOnly: todoEntity.isDueDateDateOnly,
          isDueDateReminderOn: todoEntity.isDueDateReminderOn
        ))
      }
    } catch let error {
      print("Error fetching: \(error)")
    }
    print("Todos for widget: \(todos)")
    return todos
  }
}
