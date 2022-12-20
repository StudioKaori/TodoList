//
//  TodoEditView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

enum TextFieldEditMode: String {
  case todo = "todo"
  case list = "list"
}

struct TextFieldView: View {
  let vm: HomeViewModel
  let editMode: TextFieldEditMode
  let ieEditMode: Bool
  @StateObject var todoDataManager = TodoDataManager.shared
  @State private var textFieldString = ""
  @FocusState private var editFieldFocused: Bool
  
  init(vm: HomeViewModel, editMode: TextFieldEditMode, ieEditMode: Bool) {
    self.vm = vm
    self.editMode = editMode
    self.ieEditMode = ieEditMode
    switch(editMode) {
    case .todo:
      self._textFieldString = State(initialValue: vm.editTargetTodo?.title ?? "")
    case .list:
      self._textFieldString = State(initialValue: "")
    }
  }
  
  private func submitChange() {
    switch(editMode) {
    case .todo:
      if textFieldString.isEmpty { return }
      if vm.editTargetTodo == nil { return }
      vm.editTargetTodo?.title = textFieldString
      todoDataManager.saveData()
      vm.showingEditSheet.toggle()
    case .list:
      if textFieldString.isEmpty { return }
      todoDataManager.addNewList(listTitle: textFieldString, incompleteOnly: vm.showAllTodos)
      vm.showingEditSheet.toggle()
    }
  }
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.7)
        .onTapGesture {
          vm.showingEditSheet.toggle()
        }
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        
        HStack {
          TextField("Input \(editMode.rawValue) title...", text: $textFieldString)
            .focused($editFieldFocused)
            .onSubmit {
              submitChange()
            }
            .font(.system(size: UserSettings.fontSize.body))
            .padding(.leading)
            .frame(height: 55)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(10)
          
          Button {
            submitChange()
          } label: {
            Image(systemName: "pencil.circle")
              .font(.system(size: UserSettings.fontSize.largeTitle))
              .foregroundColor(Color.theme.accent)
          }
          
          Button {
            vm.showingEditSheet.toggle()
          } label: {
            Image(systemName: "x.circle")
              .font(.system(size: UserSettings.fontSize.largeTitle))
              .foregroundColor(Color.theme.secondaryText)
          }
        } // END: Hstack AddTask Text field
        .padding()
        .onAppear {
          editFieldFocused = true
        } // END: Hstack main container
      } // END: Vstack
    }
  }
}

struct TodoEditView_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldView(vm: HomeViewModel(), editMode: .list, ieEditMode: false)
  }
}
