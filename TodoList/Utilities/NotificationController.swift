//
//  ReminderNotification.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-24.
//

import SwiftUI

final class NotificationController {
  static func sendNotificationRequest(todo: TodoEntity, date: Date){
    let content = UNMutableNotificationContent()
    content.title = todo.title ?? "Todo reminder"
    content.body = "\(LocalisedDateFormatter.getFormattedDate(date: date)) \(todo.memo ?? "")"
    
    var dateComponent = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
    dateComponent.second! += 3
    print(dateComponent)  // 以下に表示
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
  
  //  func sendNotificationRequest(){
  //    let content = UNMutableNotificationContent()
  //    content.title = "通知のタイトル"
  //    content.body = "通知の内容です"
  //
  //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
  //
  //    let request = UNNotificationRequest(identifier: UUID().uuidString , content: content, trigger: trigger)
  //    UNUserNotificationCenter.current().add(request)
  //  }
}
