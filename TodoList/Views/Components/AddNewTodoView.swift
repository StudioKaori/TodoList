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
  
  private func addTodo() {
    guard !addTodoString.isEmpty else { return }
    todoDataManager.addTodo(todoTitle: addTodoString)
    addTodoString = ""
    imageData = .init(capacity:0)
    addTodoFieldFocus = false
  }
  
  var body: some View {
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
          addTodoFieldFocus.toggle()
        } label: {
          Image(systemName: "arrow.down.circle")
            .font(.largeTitle)
            .foregroundColor(Color.theme.secondaryText)
        }
      }
    } // END: Hstack AddTask Text field
    .padding()
    .onAppear {
      addTodoFieldFocus = false
    }
    
    // CameraView
    HStack{
      CameraView(imageData: $imageData, source: $source, image: $image, isImagePicker: $isImagePicker)
        .padding(.top,50)
      NavigationLink(
        destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
        isActive:$isImagePicker,
        label: {
          Text("")
        })
    } // END: camera
  }
}

struct AddNewTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewTodoView()
  }
}
