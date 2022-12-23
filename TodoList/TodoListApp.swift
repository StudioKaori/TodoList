//
//  TodoListApp.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

@main
struct TodoListApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  //let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          //.environment(\.managedObjectContext, persistenceController.container.viewContext)
          .environmentObject(HomeViewModel())
      }
    }
  }
}
