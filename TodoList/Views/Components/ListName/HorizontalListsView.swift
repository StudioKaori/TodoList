//
//  HorizontalListsView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-20.
//

import SwiftUI

struct HorizontalListsView: View {
  @EnvironmentObject var vm: HomeViewModel
  @StateObject var todoDataManager = TodoDataManager.shared
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      
      HStack(spacing: 42) {
        
        ForEach(todoDataManager.todoLists) { list in
          Button {
            todoDataManager.updateActiveListId(id: list.id ?? DefaultValues.defaultActiveListId)
          } label: {
            VStack {
              Text(list.title ?? "No name list")
              Spacer()
              Rectangle()
                .frame(height: todoDataManager.userSettings?.activeListId == list.id ? 2 : 0)
            }
            .foregroundColor(todoDataManager.userSettings?.activeListId == list.id ? Color.theme.accent : Color.theme.primaryText)
          }
        } // END: foreach
        
        VStack {
          Button {
            vm.showListNameEdit()
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
    HorizontalListsView()
  }
}
