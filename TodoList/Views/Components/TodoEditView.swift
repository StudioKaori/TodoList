//
//  TodoEditView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct TodoEditView: View {
  let vm: HomeViewModel
  let editMode: String
  let ieEditMode: Bool
  @StateObject var todoDataManager = TodoDataManager.shared
  @State private var textFieldString = ""
  @FocusState private var editFieldFocused: Bool
  
  init(vm: HomeViewModel, editMode: String, ieEditMode: Bool) {
    self.vm = vm
    self.editMode = editMode
    self.ieEditMode = ieEditMode
    self._textFieldString = State(initialValue: vm.editTargetTodo?.title ?? "")
  }
  
  private func submitChange() {
    switch(editMode) {
    case "todo":
      if textFieldString.isEmpty { return }
      if vm.editTargetTodo == nil { return }
      vm.editTargetTodo?.title = textFieldString
      todoDataManager.saveData()
      vm.showingEditSheet.toggle()
    case "list":
      if textFieldString.isEmpty { return }
      todoDataManager.addNewList(listTitle: textFieldString, incompleteOnly: vm.showAllTodos)
      vm.showingEditSheet.toggle()
    default:
      return
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
          TextField(vm.editTargetTodo?.title ?? "", text: $textFieldString)
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
    TodoEditView(vm: HomeViewModel(), editMode: "list", ieEditMode: false)
  }
}
