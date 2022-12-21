//
//  HorizontalListsView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-20.
//

import SwiftUI

struct HorizontalListsView: View {
  @StateObject var vm: HomeViewModel
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      
      HStack(spacing: 42) {
        
        ForEach(TodoDataManager.shared.todoLists) { list in
          Button {
            TodoDataManager.shared.updateActiveListId(id: list.id ?? defaultActiveListId)
          } label: {
            VStack {
              Text(list.title ?? "No name list")
              Spacer()
              Rectangle()
                .frame(height: TodoDataManager.shared.userSettings?.activeListId == list.id ? 2 : 0)
            }
            .foregroundColor(TodoDataManager.shared.userSettings?.activeListId == list.id ? Color.theme.accent : Color.theme.primaryText)
          }
        } // END: foreach
        
        VStack {
          Button {
            vm.editMode = .list
            vm.showingEditSheet = true
          } label: {
            Image(systemName: "plus.circle")
              .foregroundColor(Color.theme.primaryText)
          }
          
          Spacer()
        }
      } // END: Hstack
      .frame(height: 30)
    }
    .font(.subheadline)
    .padding(.horizontal)
  }
}

struct HorizontalListsView_Previews: PreviewProvider {
  static var previews: some View {
    HorizontalListsView(vm: HomeViewModel())
  }
}
