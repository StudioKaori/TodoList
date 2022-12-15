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
