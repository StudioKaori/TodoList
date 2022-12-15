//
//  SimpleEntry.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
  let date: Date
  var todos: [TodoModel]
}

extension SimpleEntry {
  static func placeholder() -> SimpleEntry {
    SimpleEntry(date: Date(), todos: [TodoModel.placeholder(0), TodoModel.placeholder(1), TodoModel.placeholder(2), TodoModel.placeholder(3), TodoModel.placeholder(4), ])
  }
}
