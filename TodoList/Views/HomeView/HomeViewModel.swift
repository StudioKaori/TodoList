//
//  HomeViewModel.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var showingEditSheet: Bool = false
  @Published var editTargetTodo: TodoEntity?
  @Published var showAllTodos: Bool = false
  
  var editMode: TextFieldEditMode = .todo
  
  func showTodoEdit(entity: TodoEntity) {
    self.editTargetTodo = entity
    self.editMode = .todo
    self.showingEditSheet.toggle()
  }
  
  func move(from source: IndexSet, to destination: Int) {
//    todoDataManager.savedTodos.move(fromOffsets: source, toOffset: destination)
//    todoDataManager.saveData(incompleteOnly: vm.showAllTodos)
    print("from:\(source) to: \(destination)")
  }
}
