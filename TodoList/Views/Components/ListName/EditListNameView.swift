//
//  EditListNameView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-02-16.
//

import SwiftUI

struct EditListNameView: View {
  @EnvironmentObject var vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  @State private var textFieldString = ""
  
  @FocusState private var focus: Bool
  
  private func submitChange() {
    if textFieldString.isEmpty { return }
    todoDataManager.addNewList(listTitle: textFieldString)
    vm.showingEditSheet.toggle()
    vm.showToast(text: "The list added!")
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
          TextField("Input list title...", text: $textFieldString)
            .focused($focus)
            .font(.body)
            .padding(.leading)
            .frame(height: 55)
            .background(Color.theme.textFieldBackground)
            .cornerRadius(DefaultValues.textBorderCornerRadius)
          
          Button {
            submitChange()
          } label: {
            Image(systemName: "plus.circle")
              .font(.largeTitle)
              .foregroundColor(Color.theme.accent)
          }
          
          Button {
            vm.showingEditSheet.toggle()
          } label: {
            Image(systemName: "x.circle")
              .font(.largeTitle)
              .foregroundColor(Color.theme.secondaryText)
          }
        } // END: Hstack AddTask Text field
        .padding()
        
        // END: Hstack main container
      } // END: Vstack
      .onAppear {
        self.focus = true
      }
    }
  }
}

struct EditListNameView_Previews: PreviewProvider {
  static var previews: some View {
    EditListNameView()
  }
}
