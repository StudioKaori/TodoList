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
  
  var editTargetTodo: TodoEntity?
  
  var editMode: TextFieldEditMode = .todo
  
  func showTodoEdit(entity: TodoEntity) {
    if let imageId = entity.imageId {
      TodoDataManager.shared.imageData = TodoDataManager.shared.todoImages[imageId]
    }
    self.editTargetTodo = entity
    self.editMode = .todo
    self.showingEditSheet = true
  }
}
