//
//  TodoModel.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import Foundation

struct TodoModel: Identifiable {
  let id: String = UUID().uuidString
  let title: String
  let completed: Bool
  let isDueDateActive: Bool
  let dueDate: Date?
  let isDueDateDateOnly: Bool
  let isDueDateReminderOn: Bool
  let color: Int
}

extension TodoModel {
  static func placeholder(_ id: Int) -> TodoModel {
    TodoModel(
      title: "My Todo\(id)",
      completed: .random(),
      isDueDateActive: true,
      dueDate: Date(),
      isDueDateDateOnly: false,
      isDueDateReminderOn: true,
      color: 0
    )
  }
}
