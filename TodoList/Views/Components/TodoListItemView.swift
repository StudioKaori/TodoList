//
//  TodoListItemView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-20.
//

import SwiftUI

struct TodoListItemView: View {
  @StateObject var vm: HomeViewModel
  let entity: TodoEntity

  
  var body: some View {
    HStack {
      Image(systemName: entity.completed ? "checkmark.circle" : "circle")
        .foregroundColor(entity.completed ? Color.theme.accent : Color.theme.secondaryText)
        .onTapGesture {
          withAnimation{
            TodoDataManager.shared.updateCompleted(entity: entity, completed: !entity.completed)
          }
        }
      
      VStack(alignment: .leading) {
        
        HStack {
          Text(entity.title ?? "")
            .strikethrough(entity.completed ? true : false)
          
          if entity.dueDate != nil {
            Spacer()
            
            Text("\(LocalisedDateFormatter.getFormattedDate(date: entity.dueDate!))")
              .font(.caption2)
              .foregroundColor(Color.theme.secondaryText)
          }
        }
        
        if let imageId: String = entity.imageId {
          Image(uiImage: UIImage(data: TodoDataManager.shared.todoImages[imageId] ?? Data.init())!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .cornerRadius(10)
        }
      }
    }
    .font(.body)
    .swipeActions(edge: .trailing) {
      Button {
        withAnimation {
          TodoDataManager.shared.updateCompleted(entity: entity, completed: !entity.completed)
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
    }
    .onTapGesture {
      vm.showTodoEdit(entity: entity)
    }
    // END: Hstack list item
  }
}

struct TodoListItemView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListItemView(vm: HomeViewModel(), entity: TodoEntity(context: PersistenceController.shared.container.viewContext))
  }
}
