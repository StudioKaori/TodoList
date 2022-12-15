//
//  HomeViewModel.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-15.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var showingEditSheet = false
  @Published var editTargetTodo: TodoEntity?
}
