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
  @Published var todoLists: [ListEntity] = []
  @Published var userSettings: UserSettingsEntity?
  
  private init() {
    fetchUserSettings()
  } // END: init
  
  func countTodos() -> Int {
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    do {
      let todos = try container.viewContext.fetch(request)
      return todos.count
    } catch let error {
      print("Error fetching: \(error)")
      // Todo implement error handling
      return 0
    }
  }
  
  func fetchTodos(incompleteOnly: Bool) {
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    let sort = NSSortDescriptor(key: #keyPath(TodoEntity.order), ascending: false)
    request.sortDescriptors = [sort]
    
    if incompleteOnly {
      let predicate = NSPredicate(format: "completed == %d", false)
      request.predicate = predicate
    }
    
    do {
      savedTodos = try container.viewContext.fetch(request)
      print(savedTodos)
      
      // reload the widget
      WidgetCenter.shared.reloadTimelines(ofKind: "TodoListWidget")
    } catch let error {
      print("Error fetching: \(error)")
    }
  } // END: fetchTodos
  
  func addTodo(todoTitle: String, incompleteOnly: Bool = true) {
    let newTodo = TodoEntity(context: container.viewContext)
    newTodo.id = UUID().uuidString
    newTodo.addedDate = Date()
    newTodo.order = Int16(countTodos() + 1)
    newTodo.title = todoTitle
    newTodo.memo = ""
    newTodo.listId = userSettings?.activeListId ?? "0"
    newTodo.completed = false
    newTodo.color = 0
    //newTodo.dueDate = nil
    newTodo.starred = false
    //newTodo.image = nil
    saveData(incompleteOnly: incompleteOnly)
  } // END: addTodo
  
  func updateTodo(entity: TodoEntity, incompleteOnly: Bool = true) {
    saveData(incompleteOnly: incompleteOnly)
  } // END: updateTodo
  
  func updateCompleted(entity: TodoEntity, completed: Bool, incompleteOnly: Bool = true) {
    entity.completed = completed
    saveData(incompleteOnly: incompleteOnly)
  }
  
  func deleteTodo(entity: TodoEntity, incompleteOnly: Bool = true) {
    container.viewContext.delete(entity)
    saveData(incompleteOnly: incompleteOnly)
  }
  
  // MARK: -UserSettings
  func fetchUserSettings() {
    let request = NSFetchRequest<UserSettingsEntity>(entityName: "UserSettingsEntity")
    
    do {
      let userSettingsArray = try container.viewContext.fetch(request)
      
      if userSettingsArray.count == 0 {
        // Generate the userSettings if not exist
        generateDefaultList()
        let newUserSettings = UserSettingsEntity(context: container.viewContext)
        newUserSettings.activeListId = "0"
        saveData()
        fetchLists()
        fetchTodos(incompleteOnly: true)
      } else {
        userSettings = userSettingsArray[0]
      }
    } catch let error {
      print("Error fetching user settings: \(error)")
    }
  }
  
  func updateActiveListId(id: String) {
    userSettings?.activeListId = id
    saveData()
    
  }
  
  // MARK: - Lists
  func fetchLists() {
    let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
    do {
      todoLists = try container.viewContext.fetch(request)
      print("MyTodoLists: \(todoLists)")
    } catch let error {
      print("Error fetching fetchlist: \(error)")
    }
  }
  
  func generateDefaultList() {
    let defaultList = ListEntity(context: container.viewContext)
    defaultList.id = "0"
    defaultList.title = "Todos"
    saveData()
  }
  
  
  // MARK: - General
  func saveData(incompleteOnly: Bool = true) {
    do {
      try container.viewContext.save()
      fetchTodos(incompleteOnly: incompleteOnly)
    } catch let error {
      print("Error saving: \(error)")
    }
  } // END: saveData
}
