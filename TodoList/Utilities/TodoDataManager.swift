//
//  TodoDataManager.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import SwiftUI
import CoreData
import WidgetKit

class TodoDataManager: ObservableObject {
  
  static let shared = TodoDataManager()
  
  let container: NSPersistentContainer = PersistenceController.shared.container
  @Published var savedTodos: [TodoEntity] = []
  
  private init() {
    fetchTodos()
  } // END: init
  
  func fetchTodos() {
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    let sort = NSSortDescriptor(key: #keyPath(TodoEntity.order), ascending: false)
    request.sortDescriptors = [sort]
    
    do {
      savedTodos = try container.viewContext.fetch(request)
      print(savedTodos)
      
      // reload the widget
      WidgetCenter.shared.reloadTimelines(ofKind: "TodoListWidget")
    } catch let error {
      print("Error fetching: \(error)")
    }
  } // END: fetchTodos
  
  func addTodo(todoTitle: String) {
    let newTodo = TodoEntity(context: container.viewContext)
    newTodo.id = UUID().uuidString
    newTodo.addedDate = Date()
    newTodo.order = Int16(savedTodos.count + 1)
    newTodo.title = todoTitle
    newTodo.listId = "0"
    newTodo.completed = false
    newTodo.color = 0
    //newTodo.dueDate = nil
    newTodo.starred = false
    //newTodo.image = nil
    saveData()
  } // END: addTodo
  
  func updateTodo(entity: TodoEntity) {
    saveData()
  } // END: updateTodo
  
  func tickTodo(entity: TodoEntity) {
    container.viewContext.delete(entity)
    saveData()
  }
  
  func deleteTodo(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let entity = savedTodos[index]
    container.viewContext.delete(entity)
    saveData()
  }
  
  func saveData() {
    do {
      try container.viewContext.save()
      fetchTodos()
    } catch let error {
      print("Error saving: \(error)")
    }
  } // END: saveData
}

