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
  @Published var todoImages: [String: Data] = [:]
  @Published var todoLists: [ListEntity] = []
  @Published var userSettings: UserSettingsEntity?
  
  // For camera
  @Published var imageData: Data? = nil
  
  private init() {
    fetchUserSettings()
  } // END: init
  
  func getTodoRequest(listId: String, incompleteOnly: Bool = false) -> NSFetchRequest<TodoEntity> {
    let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    let listIdPredicate = NSPredicate(format: "listId = %@", listId)
    let sort = NSSortDescriptor(key: #keyPath(TodoEntity.order), ascending: false)
    request.sortDescriptors = [sort]
    var predicates: [NSPredicate] = [listIdPredicate]
    
    if incompleteOnly {
      let incompletePredicate = NSPredicate(format: "completed == %d", false)
      predicates.append(incompletePredicate)
    }
    
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    return request
  }
  
  func fetchTodos(activeListId: String, incompleteOnly: Bool = false) {
    do {
      savedTodos = try container.viewContext.fetch(getTodoRequest(listId: activeListId, incompleteOnly: incompleteOnly))
      //print("saved Todos: \(savedTodos)")
      
      // reload the widget
      WidgetCenter.shared.reloadTimelines(ofKind: "TodoListWidget")
      
      fetchTodoImages()
    } catch let error {
      print("Error fetching: \(error)")
    }
  } // END: fetchTodos
  
  func fetchTodoImages() {
    let request = NSFetchRequest<TodoImageEntity>(entityName: "TodoImageEntity")
    let listIdPredicate = NSPredicate(format: "listId = %@", userSettings?.activeListId ?? defaultActiveListId)
    let predicates: [NSPredicate] = [listIdPredicate]
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    
    do {
      let results = try container.viewContext.fetch(request)
      results.forEach { todoImage in
        todoImages.updateValue(todoImage.image ?? Data(), forKey: todoImage.id ?? "")
      }
      
    } catch let error {
      print("Error fetching: \(error)")
    }
  }
  
  func getNextTodoOrder(listId: String) -> Int16 {
    do {
      let todos = try container.viewContext.fetch(getTodoRequest(listId: listId, incompleteOnly: false))
      return (todos.first?.order ?? 0) + 1
    } catch let error {
      print("Error fetching: \(error)")
      // Todo implement error handling
      return 1
    }
  }
  
  func addTodo(todoTitle: String,
               isDueDateActive: Bool = false,
               dueDate: Date?,
               isDueDateDateOnly: Bool = false,
               isDueDateReminderOn: Bool = false,
               memo: String?,
               incompleteOnly: Bool = false) {
    let newTodo = TodoEntity(context: container.viewContext)
    newTodo.id = UUID().uuidString
    newTodo.addedDate = Date()
    newTodo.order = getNextTodoOrder(listId: userSettings?.activeListId ?? defaultActiveListId)
    newTodo.title = todoTitle
    newTodo.memo = memo ?? ""
    newTodo.listId = userSettings?.activeListId ?? defaultActiveListId
    newTodo.completed = false
    newTodo.color = 0
    newTodo.starred = false
    if imageData != nil {
      let newImageId = UUID().uuidString
      newTodo.imageId = newImageId
      let newImageEntity = TodoImageEntity(context: container.viewContext)
      newImageEntity.id = newImageId
      newImageEntity.image = imageData
      newImageEntity.listId = userSettings?.activeListId ?? defaultActiveListId
    }
    
    if isDueDateActive {
      guard let dueDateData: Date = dueDate else {
        print("AddTodo Error: Due date is active but the due date is nil.")
        return
      }
      newTodo.dueDate = dueDateData
      newTodo.isDueDateDateOnly = isDueDateDateOnly
      if isDueDateReminderOn {
        NotificationController.sendNotificationRequest(todo: newTodo, date: dueDateData)
      }
    }
    
    saveData(incompleteOnly: incompleteOnly)
  } // END: addTodo
  
  func updateTodo(entity: TodoEntity, incompleteOnly: Bool = false) {
    saveData(incompleteOnly: incompleteOnly)
  } // END: updateTodo
  
  func updateCompleted(entity: TodoEntity, completed: Bool, incompleteOnly: Bool = false) {
    entity.completed = completed
    saveData(incompleteOnly: incompleteOnly)
  }
  
  func deleteTodo(entity: TodoEntity, incompleteOnly: Bool = false) {
    container.viewContext.delete(entity)
    saveData(incompleteOnly: incompleteOnly)
  }
  
  func updateTodosOrder() {
    savedTodos.reversed().enumerated().forEach { (index, todo) in
      todo.order = Int16(index)
    }
    saveData()
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
        newUserSettings.activeListId = defaultActiveListId
        newUserSettings.widgetListId = defaultWidgetListId
        WidgetDataManager.shared.widgetListId = defaultWidgetListId
        saveData()
      } else {
        userSettings = userSettingsArray[0]
      }
      
      fetchLists()
      fetchTodos(activeListId: userSettings?.activeListId ?? defaultActiveListId, incompleteOnly: false)
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
      //print("MyTodoLists: \(todoLists)")
    } catch let error {
      print("Error fetching fetchlist: \(error)")
    }
  }
  
  func addNewList(listTitle: String, incompleteOnly: Bool = false) {
    if listTitle == "" { return }
    let newList = ListEntity(context: container.viewContext)
    newList.id = UUID().uuidString
    newList.title = listTitle
    newList.order = getNextListOrder()
    userSettings?.activeListId = newList.id
    saveData(incompleteOnly: incompleteOnly)
  }
  
  func getNextListOrder() -> Int16 {
    let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
    do {
      let lists = try container.viewContext.fetch(request)
      return (lists.first?.order ?? 0) + 1
    } catch let error {
      print("Error fetching: \(error)")
      // Todo implement error handling
      return 1
    }
  }
  
  //  func updateListsOrder() {
  //    todoLists.reversed().enumerated().forEach { (index, list) in
  //      list.order = Int16(index)
  //    }
  //    saveData()
  //  }
  
  func generateDefaultList() {
    let defaultList = ListEntity(context: container.viewContext)
    defaultList.id = defaultActiveListId
    defaultList.title = "Todos"
    saveData()
  }
  
  
  // MARK: - General
  func saveData(incompleteOnly: Bool = false) {
    do {
      try container.viewContext.save()
      imageData = nil
      fetchLists()
      fetchTodos(activeListId: userSettings?.activeListId ?? defaultActiveListId, incompleteOnly: incompleteOnly)
    } catch let error {
      print("Error saving: \(error)")
    }
  } // END: saveData
}
