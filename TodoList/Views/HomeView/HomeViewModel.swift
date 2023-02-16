//
//  HomeViewModel.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var showingEditSheet: Bool = false
  @Published var showAllTodos: Bool = false
  @Published var showToast: Bool = false
  
  // For toast
  var toastText = ""
  var toastIconName = ""
  
  var editTargetTodo: TodoEntity?
  
  var editMode: EditTarget = .todo
  
  func showTodoEdit(entity: TodoEntity) {
    self.editTargetTodo = entity
    self.editMode = .todo
    self.showingEditSheet = true
  }
  
  func showListNameEdit() {
    self.editMode = .list
    self.showingEditSheet = true
  }
  
  func showToast(text: String, iconName: String = "checkmark.circle") {
    print(text)
    self.toastText = text
    self.toastIconName = iconName
    self.showToast.toggle()
  }
}

enum EditTarget: String {
  case todo = "todo"
  case list = "list"
}
