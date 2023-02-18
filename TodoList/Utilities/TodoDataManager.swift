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
    let listIdPredicate = NSPredicate(format: "listId = %@", userSettings?.activeListId ?? DefaultValues.defaultActiveListId)
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
  
  func fetchTodoImageEntityByImageId(imageId: String) -> TodoImageEntity? {
    let request = NSFetchRequest<TodoImageEntity>(entityName: "TodoImageEntity")
    let predicate = NSPredicate(format: "id = %@", imageId)
    var predicates: [NSPredicate] = [predicate]
    
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    do {
      let imageData = try container.viewContext.fetch(request)
      return imageData[0]
    } catch let error {
      print("Error fetching: \(error)")
      return nil
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
  
  fileprivate func checkAndSetReminder(todoEntity: TodoEntity) {
    guard todoEntity.isDueDateActive,
          todoEntity.isDueDateReminderOn,
          var reminderDueDate = todoEntity.dueDate else {
      print("Reminser is not set")
      return
    }
    
    if todoEntity.isDueDateDateOnly {
      let reminderTime = userSettings?.reminderTime ?? DefaultValues.userSettingsDefaultReminderTime
      reminderDueDate = Calendar.current.date(bySettingHour: Int(reminderTime.split(separator: ":")[0])!, minute: Int(reminderTime.split(separator: ":")[1])!, second: 0, of: todoEntity.dueDate!)!
    }
    NotificationController.sendNotificationRequest(todo: todoEntity, date: reminderDueDate)
  }
  
  func addTodo(todoTitle: String,
               todoBgColor: Int = 0,
               isDueDateActive: Bool = DefaultValues.todoDefaultIsDueDateActive,
               dueDate: Date?,
               isDueDateDateOnly: Bool = DefaultValues.todoDefaultIsDueDateDateOnly,
               isDueDateReminderOn: Bool = DefaultValues.todoDefaultIsDueDateReminderOn,
               memo: String,
               incompleteOnly: Bool = false) {
    editTodo(todoTitle: todoTitle,
             todoBgColor: todoBgColor,
             isDueDateActive: isDueDateActive,
             dueDate: dueDate,
             isDueDateDateOnly: isDueDateDateOnly,
             isDueDateReminderOn: isDueDateReminderOn,
             memo: memo,
             incompleteOnly: incompleteOnly)
    
//    let newTodo = TodoEntity(context: container.viewContext)
//    newTodo.id = UUID().uuidString
//    newTodo.addedDate = Date()
//    newTodo.order = getNextTodoOrder(listId: userSettings?.activeListId ?? DefaultValues.defaultActiveListId)
//    newTodo.title = todoTitle
//    newTodo.memo = memo
//    newTodo.listId = userSettings?.activeListId ?? DefaultValues.defaultActiveListId
//    newTodo.completed = false
//    newTodo.color = Int16(todoBgColor)
//    newTodo.starred = false
//    if imageData != nil {
//      let newImageId = UUID().uuidString
//      newTodo.imageId = newImageId
//      let newImageEntity = TodoImageEntity(context: container.viewContext)
//      newImageEntity.id = newImageId
//      newImageEntity.image = imageData
//      newImageEntity.listId = userSettings?.activeListId ?? DefaultValues.defaultActiveListId
//    }
//
//    newTodo.isDueDateActive = isDueDateActive
//    if isDueDateActive {
//      guard let dueDateData: Date = dueDate else {
//        print("AddTodo Error: Due date is active but the due date is nil.")
//        return
//      }
//      newTodo.dueDate = isDueDateDateOnly ? Calendar.current.startOfDay(for: dueDateData) : dueDateData
//      newTodo.isDueDateDateOnly = isDueDateDateOnly
//      newTodo.isDueDateReminderOn = isDueDateReminderOn
//      checkAndSetReminder(todoEntity: newTodo)
//    }
//
//    saveData(incompleteOnly: incompleteOnly)
  } // END: addTodo
  
  func editTodo(isEditMode: Bool = false,
               todoEntity: TodoEntity? = nil,
               todoTitle: String,
               todoBgColor: Int = 0,
               isDueDateActive: Bool = DefaultValues.todoDefaultIsDueDateActive,
               dueDate: Date?,
               isDueDateDateOnly: Bool = DefaultValues.todoDefaultIsDueDateDateOnly,
               isDueDateReminderOn: Bool = DefaultValues.todoDefaultIsDueDateReminderOn,
               memo: String,
               incompleteOnly: Bool = false) {
    var todo: TodoEntity
    
    if isEditMode {
      guard let editedTodo = todoEntity else { return }
      todo = editedTodo
    } else {
      todo = TodoEntity(context: container.viewContext)
    }
    
    todo.id = UUID().uuidString
    todo.addedDate = Date()
    todo.order = isEditMode ? todo.order : getNextTodoOrder(listId: userSettings?.activeListId ?? DefaultValues.defaultActiveListId)
    todo.title = todoTitle
    todo.memo = memo
    todo.listId = userSettings?.activeListId ?? DefaultValues.defaultActiveListId
    todo.completed = false
    todo.color = Int16(todoBgColor)
    todo.starred = false
    if imageData != nil {
      let newImageId = UUID().uuidString
      todo.imageId = newImageId
      let newImageEntity = TodoImageEntity(context: container.viewContext)
      newImageEntity.id = newImageId
      newImageEntity.image = imageData
      newImageEntity.listId = userSettings?.activeListId ?? DefaultValues.defaultActiveListId
    }
    
    todo.isDueDateActive = isDueDateActive
    if isDueDateActive {
      guard let dueDateData: Date = dueDate else {
        print("AddTodo Error: Due date is active but the due date is nil.")
        return
      }
      todo.dueDate = isDueDateDateOnly ? Calendar.current.startOfDay(for: dueDateData) : dueDateData
      todo.isDueDateDateOnly = isDueDateDateOnly
      todo.isDueDateReminderOn = isDueDateReminderOn
      checkAndSetReminder(todoEntity: todo)
    }
    
    saveData(incompleteOnly: incompleteOnly)
  } // END: editTodo
  
  func updateCompleted(todo: TodoEntity, completed: Bool, incompleteOnly: Bool = false) {
    todo.completed = completed
    if completed {
      // Cancel notification
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todo.id!])
    } else {
      // Add notification again
      checkAndSetReminder(todoEntity: todo)
    }
    saveData(incompleteOnly: incompleteOnly)
  }
  
  func deleteTodoImageEntity(imageId: String) {
    if let todoImageEntity = fetchTodoImageEntityByImageId(imageId: imageId) {
      container.viewContext.delete(todoImageEntity)
    }
  }
  
  func deleteTodo(entity: TodoEntity, incompleteOnly: Bool = false) {
    container.viewContext.delete(entity)
    if let imageId = entity.imageId {
      deleteTodoImageEntity(imageId: imageId)
    }
    saveData(incompleteOnly: incompleteOnly)
  }
  
  func updateTodosOrder() {
    savedTodos.reversed().enumerated().forEach { (index, todo) in
      todo.order = Int16(index)
    }
    saveData()
  }
  
  // MARK: -UserSettings
  fileprivate func generateNewUserSettings() {
    // Generate the userSettings if not exist
    generateDefaultList()
    let newUserSettings = UserSettingsEntity(context: container.viewContext)
    newUserSettings.activeListId = DefaultValues.defaultActiveListId
    newUserSettings.widgetListId = DefaultValues.defaultWidgetListId
    newUserSettings.reminderTime = DefaultValues.userSettingsDefaultReminderTime
    WidgetDataManager.shared.widgetListId = DefaultValues.defaultWidgetListId
    saveData()
  }
  
  func fetchUserSettings() {
    let request = NSFetchRequest<UserSettingsEntity>(entityName: "UserSettingsEntity")
    
    do {
      let userSettingsArray = try container.viewContext.fetch(request)
      
      if userSettingsArray.count == 0 {
        generateNewUserSettings()
      } else {
        userSettings = userSettingsArray[0]
      }
      
      fetchLists()
      fetchTodos(activeListId: userSettings?.activeListId ?? DefaultValues.defaultActiveListId, incompleteOnly: false)
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
    defaultList.id = DefaultValues.defaultActiveListId
    defaultList.title = "Todos"
    saveData()
  }
  
  
  // MARK: - General
  func saveData(incompleteOnly: Bool = false) {
    do {
      try container.viewContext.save()
      imageData = nil
      fetchLists()
      fetchTodos(activeListId: userSettings?.activeListId ?? DefaultValues.defaultActiveListId, incompleteOnly: incompleteOnly)
    } catch let error {
      print("Error saving: \(error)")
    }
  } // END: saveData
}
