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
  @State var isDueDateReminderOn: Bool = DefaultValues.todoDefaultIsDueDateReminderOn
  @State var isDueDateActive: Bool = DefaultValues.todoDefaultIsDueDateActive
  @State var showDatePickerSheet: Bool = false
  
  // Bg color
  @State var todoBgColor: String = "none"
  
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
    isDueDateDateOnly = DefaultValues.todoDefaultIsDueDateDateOnly
    isDueDateReminderOn = DefaultValues.todoDefaultIsDueDateReminderOn
    isDueDateActive = DefaultValues.todoDefaultIsDueDateActive
    showDatePickerSheet = false
  }
  
  var body: some View {
    VStack(alignment: .leading) {
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
          .cornerRadius(DefaultValues.textBorderCornerRadius)
        
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
      .padding(.bottom, 14)
      
      HStack(spacing: 12) {
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
            .modifier(TextBorder(color: Color.theme.accent))
            
          } else {
            Text("Add due date")
              .modifier(TextBorder(color: Color.theme.primaryText))
            
            Button {
              isDueDateActive = true
              dueDate = Date()
              isDueDateDateOnly = true
            } label: {
              Text("Today")
                .modifier(TextBorder(color: Color.theme.primaryText))
            }
            
            Button {
              isDueDateActive = true
              dueDate = Calendar.current.date(byAdding: .day,value: 1, to: Date())!
              isDueDateDateOnly = true
            } label: {
              Text("Tomorrow")
                .modifier(TextBorder(color: Color.theme.primaryText))
            }
          }
        }
        
      }
      .foregroundColor(Color.theme.primaryText)
      .font(.footnote)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          Button {
            
          } label: {
            Image(systemName: "note.text")
              .foregroundColor(Color.theme.primaryText)
          }
          
          AttachTodoImageView(imageData: $imageData, source: $source, image: $image, isImagePicker: $isImagePicker)
          
          Button {
            todoBgColor = "none"
          } label: {
            Image(systemName: "slash.circle")
              .foregroundColor(Color.theme.secondaryText)
              .modifier(IconBorder(borderWidth: todoBgColor == "none" ? 1 : 0))
          }
          
          ForEach(Color.todoBgTheme.colors) { color in
            Button {
              todoBgColor = color.key
            } label: {
              Image(systemName: "circle.fill")
                .foregroundColor(color.value)
                .modifier(IconBorder(borderWidth: todoBgColor == color.key ? 1 : 0))
            }
          }

        }
        .padding(.vertical, 12)
      } // END: scroll view
      .font(.system(size: DefaultValues.editTodoIconSize))
      
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

struct TextBorder: ViewModifier {
  let color: Color
  
  func body(content: Content) -> some View {
    content
      .padding(4)
      .overlay(
        RoundedRectangle(cornerRadius: DefaultValues.textBorderCornerRadius)
          .stroke(color, lineWidth: 1)
      )
  }
}

struct IconBorder: ViewModifier {
  let borderWidth: CGFloat
  
  func body(content: Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.theme.primaryText, lineWidth: borderWidth)
      )
  }
}
