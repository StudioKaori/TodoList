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
  @State var memoString: String = ""
  
  // For image picker
  @State private var image = Image(systemName: "photo")
  @State var imageData: Data = .init(capacity:0)
  @State var isImagePicker = false
  @State var source:UIImagePickerController.SourceType = .photoLibrary
  
  // Due Date
  @State var dueDate: Date = Date()
  @State var isDueDateDateOnly: Bool = true
  @State var isDueDateReminderOn: Bool = todoDefaultIsDueDateReminderOn
  @State var isDueDateActive: Bool = todoDefaultIsDueDateActive
  @State var showDatePickerSheet: Bool = false
  
  private func addTodo() {
    guard !addTodoString.isEmpty else { return }
    todoDataManager.addTodo(
      todoTitle: addTodoString,
      isDueDateActive: isDueDateActive,
      dueDate: dueDate,
      isDueDateDateOnly: isDueDateDateOnly,
      isDueDateReminderOn: isDueDateReminderOn,
      memo: memoString
    )
    
    resetFields()
  }
  
  private func resetFields() {
    addTodoString = ""
    imageData = .init(capacity:0)
    addTodoFieldFocus = false
    
    // Due date
    dueDate = Date()
    isDueDateDateOnly = todoDefaultIsDueDateDateOnly
    isDueDateReminderOn = todoDefaultIsDueDateReminderOn
    isDueDateActive = todoDefaultIsDueDateActive
    showDatePickerSheet = false
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
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
          .cornerRadius(textBorderCornerRadius)
        
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
        Button {
          if !isDueDateActive {
            dueDate = Date()
          }
          
          isDueDateActive = true
          showDatePickerSheet.toggle()
        } label: {
          if isDueDateActive {
            HStack {
              Text(isDueDateDateOnly ? LocalisedDateFormatter.getFormattedDate(date: dueDate) : LocalisedDateFormatter.getFormattedDateAndTime(date: dueDate))
              
              if isDueDateReminderOn {
                Image(systemName: "bell.fill")
              }
            }
            .foregroundColor(Color.theme.accent)
            .modifier(Border(color: Color.theme.accent))
            
          } else {
            Text("Add due date")
              .modifier(Border(color: Color.theme.primaryText))
            
            Button {
              isDueDateActive = true
              dueDate = Date()
              isDueDateDateOnly = true
            } label: {
              Text("Today")
                .modifier(Border(color: Color.theme.primaryText))
            }
            
            Button {
              isDueDateActive = true
              dueDate = Calendar.current.date(byAdding: .day,value: 1, to: Date())!
              isDueDateDateOnly = true
            } label: {
              Text("Tomorrow")
                .modifier(Border(color: Color.theme.primaryText))
            }
          }
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
    } // END: main Vstack
    .sheet(isPresented: $showDatePickerSheet) {
      DueDatePickerView(dueDate: $dueDate,
                        isDueDateDateOnly: $isDueDateDateOnly,
                        isDueDateReminderOn: $isDueDateReminderOn,
                        isDueDateActive: $isDueDateActive,
                        showDatePickerSheet: $showDatePickerSheet)
    }
    
  }
}

struct AddNewTodoView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewTodoView()
  }
}

struct Border: ViewModifier {
  let color: Color
  
  func body(content: Content) -> some View {
    content
      .padding(4)
      .overlay(
        RoundedRectangle(cornerRadius: textBorderCornerRadius)
          .stroke(color, lineWidth: 1)
      )
  }
}
