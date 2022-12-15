//
//  TodoEditView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct TodoEditView: View {
  let vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  @State private var todoString = ""
  @FocusState private var editFieldFocused: Bool
  
  init(vm: HomeViewModel) {
    self.vm = vm
    self._todoString = State(initialValue: vm.editTargetTodo?.title ?? "")
  }
  
  private func updateTodo() {
    if todoString.isEmpty { return }
    if vm.editTargetTodo == nil { return }
    vm.editTargetTodo?.title = todoString
    todoDataManager.saveData()
    vm.showingEditSheet.toggle()
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
          TextField(vm.editTargetTodo?.title ?? "", text: $todoString)
            .focused($editFieldFocused)
            .onSubmit {
              updateTodo()
            }
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(10)
          
          Button {
            updateTodo()
          } label: {
            Image(systemName: "pencil.circle")
              .font(.system(size: 32))
              .foregroundColor(Color.theme.accent)
          }
          
          Button {
            vm.showingEditSheet.toggle()
          } label: {
            Image(systemName: "x.circle")
              .font(.system(size: 32))
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
    TodoEditView(vm: HomeViewModel())
  }
}
