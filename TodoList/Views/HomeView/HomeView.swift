//
//  HomeView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject var vm = HomeViewModel()
  @StateObject private var todoDataManager = TodoDataManager.shared
  @FocusState private var addTodoFieldFocus: Bool
  
  @State private var addTodoString: String = ""
  
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
    ZStack {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        Text("Todos")
          .font(.headline)
          .padding(.bottom, 30)
        
        HorizontalListsView(vm: vm)
        
        TodoListView(vm: vm)
        
        Spacer()
        
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
        
      } // END: Vstack Main container
      
      if vm.showingEditSheet {
        TextFieldView(vm: vm, editMode: vm.editMode, ieEditMode: true)
      }
    } // END: Zstack
    .onAppear {
      addTodoFieldFocus = false
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.locale, Locale(identifier: "ja-jp"))
  }
}
