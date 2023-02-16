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
  
  var editMode: TextFieldEditMode = .todo
  
  func showTodoEdit(entity: TodoEntity) {
    self.editTargetTodo = entity
    self.editMode = .todo
    self.showingEditSheet = true
  }
  
  func showToast(text: String, iconName: String) {
    print(text)
    self.toastText = text
    self.toastIconName = iconName
    self.showToast.toggle()
  }
}
