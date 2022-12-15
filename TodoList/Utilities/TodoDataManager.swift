//
//  TodoDataManager.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import SwiftUI
import CoreData

class TodoDataManager: ObservableObject {
  
  static let shared = TodoDataManager()
  
  let container: NSPersistentContainer = PersistenceController.shared.container
  @Published var savedTodos: [TodoEntity] = []
  
  init() {
    fetchTodos()
  } // END: init
  
  func fetchTodos() {
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    
    do {
      savedTodos = try container.viewContext.fetch(request)
    } catch let error {
      print("Error fetching: \(error)")
    }
  } // END: fetchTodos
  
  func addTodo(todoTitle: String) {
    let newTodo = TodoEntity(context: container.viewContext)
    newTodo.title = todoTitle
    saveData()
  } // END: addTodo
  
  func updateTodo(entity: TodoEntity, newTodo: TodoModel) {
    let currentTitle = entity.title ?? ""
    let newTitle = newTodo.title
    entity.title = newTitle
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

