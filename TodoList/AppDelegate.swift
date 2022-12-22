//
//  AppDelegate.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-22.
//

import Foundation
import UIKit

class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted {
        print("Notification access granted")
      }else{
        print("Notification access declined")
      }
    }
    return true
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([[.banner, .list, .sound]])
    }
}
