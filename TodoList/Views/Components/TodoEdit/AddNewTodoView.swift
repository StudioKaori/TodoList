//
//  AddNewTodoView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-21.
//

import SwiftUI

struct AddNewTodoView: View {
  @State private var addTodoString: String = ""
  @FocusState private var addTodoFieldFocus: Bool
  @StateObject private var todoDataManager = TodoDataManager.shared
  
  // For image picker
  @State private var image = Image(systemName: "photo")
  @State var imageData: Data = .init(capacity:0)
  @State var isImagePicker = false
  @State var source:UIImagePickerController.SourceType = .photoLibrary
  
  @State var dueDate: Date?
  @State var showDatePickerSheet: Bool = false
  
  private func addTodo() {
    guard !addTodoString.isEmpty else { return }
    todoDataManager.addTodo(todoTitle: addTodoString, dueDate: dueDate)
    resetFields()
  }
  
  private func resetFields() {
    addTodoString = ""
    imageData = .init(capacity:0)
    addTodoFieldFocus = false
  }
  
  var body: some View {
    VStack {
      HStack {
        TextField("Add new todo...", text: $addTodoString)
          .focused($addTodoFieldFocus)
          .onSubmit {
            addTodo()
          }
          .font(.body)
          .padding(.leading)
          .frame(height: 55)
          .background(Color.theme.textFieldBackground)
          .cornerRadius(10)
        
        Button {
          addTodo()
        } label: {
          Image(systemName: "plus.circle")
            .font(.largeTitle)
            .foregroundColor(Color.theme.accent)
        }
        
        if addTodoFieldFocus {
          Button {
            resetFields()
          } label: {
            Image(systemName: "arrow.down.circle")
              .font(.largeTitle)
              .foregroundColor(Color.theme.secondaryText)
          }
        }
      } // END: Hstack AddTask Text field
      
      HStack(spacing: 6) {
        
        if dueDate != nil {
          Text("Due Date; \(LocalisedDateFormatter.getFormattedDate(date: dueDate!))")
        }
        
        Button {
          dueDate = Date()
        } label: {
          Text("Today")
        }
        
        Button {
          dueDate = Date() + 10
        } label: {
          Text("Tomorrow")
        }

      }
      .foregroundColor(Color.theme.primaryText)
      .font(.footnote)
      
      ScrollView(.horizontal, showsIndicators: false) {
        AttachTodoImageView(imageData: $imageData, source: $source, image: $image, isImagePicker: $isImagePicker)
      } // END: camera
    } // END: Vstack
    .padding()
    .onAppear {
      addTodoFieldFocus = false
    }
    
  }
}

struct AddNewTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewTodoView()
  }
}
