//
//  TodoListItemView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-20.
//

import SwiftUI

struct TodoListItemView: View {
  @EnvironmentObject var vm: HomeViewModel
  let entity: TodoEntity
  @Binding var showToast: Bool
  
  @State var isShowingImageSheet = false
  
  var body: some View {
    HStack {
      Image(systemName: entity.completed ? "checkmark.circle" : "circle")
        .foregroundColor(entity.completed ? Color.theme.accent : Color.theme.secondaryText)
        .onTapGesture {
          withAnimation{
            TodoDataManager.shared.updateCompleted(entity: entity, completed: !entity.completed)
            self.showToast.toggle()
          }
        }
      
      VStack(alignment: .leading) {
        
        VStack(alignment: .leading, spacing: 4) {
          Text(entity.title ?? "")
            .strikethrough(entity.completed ? true : false)
          
          if entity.dueDate != nil {
            HStack(spacing: 2) {
              Image(systemName: "calendar.badge.clock")
              Text("\(LocalisedDateFormatter.getFormattedDate(date: entity.dueDate!))")
              
              if entity.isDueDateReminderOn {
                Image(systemName: "bell.fill")
              }
            }
            .font(.caption)
            .foregroundColor(Color.theme.secondaryText)
          }
          
        }
        .onTapGesture {
          vm.showTodoEdit(entity: entity)
        } // END: Title Hstack
        
        if let imageId: String = entity.imageId {
          Button {
            isShowingImageSheet = true
          } label: {
            Image(uiImage: UIImage(data: TodoDataManager.shared.todoImages[imageId] ?? Data.init())!)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(maxWidth: .infinity)
              .frame(height: 120)
              .cornerRadius(6)
          }
          .buttonStyle(BorderlessButtonStyle())
          
        } // END: Image
        
      }
    }
    .font(.body)
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      Button {
        withAnimation {
          TodoDataManager.shared.updateCompleted(entity: entity, completed: !entity.completed)
          self.showToast.toggle()
        }
      } label: {
        Image(systemName: entity.completed ? "circle" : "checkmark.circle.fill")
      }
      .tint(Color.theme.accent)
    }
    .swipeActions(edge: .leading, allowsFullSwipe: false) {
      Button {
        withAnimation {
          TodoDataManager.shared.deleteTodo(entity: entity)
        }
      } label: {
        Image(systemName: "trash")
      }
      .tint(.red)
      
      Button {
        withAnimation {
          vm.showTodoEdit(entity: entity)
        }
      } label: {
        Image(systemName: "pencil")
      }
      .tint(.blue)
    }// END: Hstack list item
    .sheet(isPresented: $isShowingImageSheet) {
      TodoImageView(imageId: entity.imageId!, navigationbarTitle: String(entity.title?.prefix(20) ?? ""), isShowingImageSheet: $isShowingImageSheet)
    }
    
  }
}

//struct TodoListItemView_Previews: PreviewProvider {
//  static var previews: some View {
//    TodoListItemView(entity: TodoEntity(context: PersistenceController.shared.container.viewContext), showToast: .constant(true))
//  }
//}
