//
//  TodoListManager.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-19.
//

import Foundation
import CoreData

class TodoListsManager: ObservableObject {
  
  static let shared = TodoListsManager()
  
  let container: NSPersistentContainer = PersistenceController.shared.container
  
  private init() {
    
  }
  
  func generateDefaultList() {
    let defaultList = ListEntity(context: container.viewContext)
    defaultList.id = "0"
    defaultList.title = "Todos"
  }
  
//  func saveData() {
//    do {
//      try container.viewContext.save()
//    } catch let error {
//      print("Error saving TodoListManager: \(error)")
//    }
//  }
}
