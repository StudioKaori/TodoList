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
  let dueDate: Date?
}

extension TodoModel {
  static func placeholder(_ id: Int) -> TodoModel {
    TodoModel(title: "My Todo\(id)", completed: .random(), dueDate: Date())
  }
}
