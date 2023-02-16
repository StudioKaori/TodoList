//
//  AddNewTodoView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-21.
//

import SwiftUI

struct TodoInputFieldsView: View {
  @EnvironmentObject var vm: HomeViewModel
  @StateObject private var todoDataManager = TodoDataManager.shared
  @FocusState private var addTodoFieldFocus: Bool
  
  let isEditMode: Bool
  var todoEntity: TodoEntity?
  
  // MARK: - Task attributes
  
  // Strings
  @State private var addTodoString: String = ""
  @State var todoDescription: String = ""
  
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
  @State var showDescriptionSheet: Bool = false
  
  // Bg color
  @State var todoBgColor: Int = 0
  
  // MARK: - functions
  private func tappedSubmit() {
    guard !addTodoString.isEmpty else { return }
    submitTodo()
  }
  
  private func submitTodo() {
    todoDataManager.editTodo(
      isEditMode: isEditMode,
      todoEntity: todoEntity,
      todoTitle: addTodoString,
      todoBgColor: todoBgColor,
      isDueDateActive: isDueDateActive,
      dueDate: dueDate,
      isDueDateDateOnly: isDueDateDateOnly,
      isDueDateReminderOn: isDueDateReminderOn,
      memo: todoDescription
    )
    
    resetFields()
    vm.showToast(text: isEditMode ? "Todo updated!" : "Todo added!",
                 iconName: "checkmark.circle")
    
    if isEditMode {
      vm.showingEditSheet.toggle()
    }
  }
  
  private func initialiseTodoAttributes(todoEntity: TodoEntity?) {
    if todoEntity == nil {
      // reset all attributes
      addTodoString = ""
      todoDescription = ""
      imageData = .init(capacity:0)
      addTodoFieldFocus = false
      
      // Due date
      dueDate = Date()
      isDueDateDateOnly = DefaultValues.todoDefaultIsDueDateDateOnly
      isDueDateReminderOn = DefaultValues.todoDefaultIsDueDateReminderOn
      isDueDateActive = DefaultValues.todoDefaultIsDueDateActive
      showDatePickerSheet = false
      showDescriptionSheet = false
      
      todoBgColor = 0
    } else {
      guard let todo = todoEntity else { return }
      
      addTodoString = todo.title ?? ""
      todoDescription = todo.memo ?? ""
      if let imageId = todo.imageId {
        imageData = TodoDataManager.shared.todoImages[imageId] ?? .init(capacity:0)
      } else {
        imageData = .init(capacity:0)
      }
      addTodoFieldFocus = true
      
      // Due date
      dueDate = todo.dueDate ?? Date()
      isDueDateDateOnly = todo.isDueDateDateOnly
      isDueDateReminderOn = todo.isDueDateReminderOn
      isDueDateActive = todo.isDueDateActive
      showDatePickerSheet = false
      showDescriptionSheet = false
      
      todoBgColor = Int(todo.color)
    }
    
  }
  
  private func resetFields() {
    initialiseTodoAttributes(todoEntity: nil)
  }
  
  private func initialiseEditMode() {
    if isEditMode {
      guard let todo = todoEntity else {
        // todo implement error handling in case the todoEntity is nil for the edit mode
        return
      }
      
      initialiseTodoAttributes(todoEntity: todo)
    }
  }
  
  // MARK: - Body
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        TextField("Add new todo...", text: $addTodoString)
          .focused($addTodoFieldFocus)
          .onSubmit {
            tappedSubmit()
          }
          .font(.body)
          .padding(.leading)
          .frame(height: 55)
          .background(Color.theme.textFieldBackground)
          .cornerRadius(DefaultValues.textBorderCornerRadius)
        
        Button {
          tappedSubmit()
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
            showDescriptionSheet.toggle()
          } label: {
            Image(systemName: "note.text")
              .foregroundColor(todoDescription == "" ? Color.theme.primaryText : Color.theme.accent)
          }
          
          AttachTodoImageView(imageData: $imageData, source: $source, image: $image, isImagePicker: $isImagePicker)
          
          Button {
            todoBgColor = 0
          } label: {
            Image(systemName: "slash.circle")
              .foregroundColor(Color.theme.secondaryText)
              .modifier(IconBorder(borderWidth: todoBgColor == 0 ? 1 : 0))
          }
          
          ForEach(1 ..< Color.todoBgTheme.colors.count) { index in
            Button {
              todoBgColor = index
            } label: {
              Image(systemName: "circle.fill")
                .foregroundColor(Color.todoBgTheme.colors[index].colorValue)
                .modifier(IconBorder(borderWidth: todoBgColor == index ? 1 : 0))
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
      initialiseEditMode()
    } // END: main Vstack
    .sheet(isPresented: $showDatePickerSheet) {
      DueDatePickerView(dueDate: $dueDate,
                        isDueDateDateOnly: $isDueDateDateOnly,
                        isDueDateReminderOn: $isDueDateReminderOn,
                        isDueDateActive: $isDueDateActive,
                        showDatePickerSheet: $showDatePickerSheet)
    }
    .sheet(isPresented: $showDescriptionSheet) {
      TodoDescriptionView(todoDescription: $todoDescription, showDescriptionSheet: $showDescriptionSheet)
    }
    
  }
}

struct AddNewTodoView_Previews: PreviewProvider {
  static var previews: some View {
    TodoInputFieldsView(isEditMode: true)
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
