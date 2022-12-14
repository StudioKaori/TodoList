//
//  PersistenceController.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  //    static var preview: PersistenceController = {
  //        let result = PersistenceController(inMemory: true)
  //        let viewContext = result.container.viewContext
  //        for _ in 0..<10 {
  //            let newItem = Item(context: viewContext)
  //            newItem.timestamp = Date()
  //        }
  //        do {
  //            try viewContext.save()
  //        } catch {
  //            // Replace this implementation with code to handle the error appropriately.
  //            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
  //            let nsError = error as NSError
  //            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
  //        }
  //        return result
  //    }()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "TodoContainer")
    
    // For sharing the coredata between main and widget, set up the group
    let appGroupContainerURL = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: "group.com.studioKaori.TodoList")!
    let storeURL = appGroupContainerURL.appendingPathComponent("TodoEntity")
    container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
    
    // For preview, (Can be deleted)
//    if inMemory {
//      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
