//
//  HomeViewModel.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI
import CoreData

class HomeViewModel: ObservableObject {
  
  let container: NSPersistentCloudKitContainer = PersistenceController.shared.container
  @Published var savedTodos: [TodoEntity] = []
  
  init() {
//    container = NSPersistentCloudKitContainer(name: "TodoContainer")
//    container.loadPersistentStores { description, error in
//      if let error = error {
//        print("Error loading core data: \(error)")
//      }
//    }
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
  
  func updateTodo(entity: TodoEntity) {
    let currentTitle = entity.title ?? ""
    let newTitle = currentTitle + "!"
    entity.title = newTitle
    saveData()
  } // END: updateTodo
  
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
