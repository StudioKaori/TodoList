//
//  UserSettingsManager.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-19.
//

import Foundation
import CoreData

class UserSettingsManager: ObservableObject {
  
  static let shared = UserSettingsManager()
  
  let container: NSPersistentContainer = PersistenceController.shared.container
  @Published var userSettings: UserSettingsEntity?
  
  private init() {
    fetchUserSettings()
  }
  
  func fetchUserSettings() {
    let request = NSFetchRequest<UserSettingsEntity>(entityName: "TodoEntity")
    
    do {
      let userSettingsArray = try container.viewContext.fetch(request)
      
      if userSettingsArray.count == 0 {
        // Generate the userSettings if not exist
        TodoListsManager.shared.generateDefaultList()
        let newUserSettings = UserSettingsEntity(context: container.viewContext)
        newUserSettings.activeListId = "0"
        saveData()
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
  
  func saveData() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error saving userSettings: \(error)")
    }
  }
}
