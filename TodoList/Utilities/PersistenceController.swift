//
//  PersistenceController.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentContainer
  
  private init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "TodoContainer")
    
    // For sharing the coredata between main and widget, set up the group
    let appGroupContainerURL = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: "group.com.studioKaori.TodoList")!
    let storeURL = appGroupContainerURL.appendingPathComponent("TodoEntity")
    container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
