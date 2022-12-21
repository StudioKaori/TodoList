//
//  HomeView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

struct HomeView: View {
  
  @StateObject var vm = HomeViewModel()

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
        
        AddNewTodoView()
      } // END: Vstack Main container
      
      if vm.showingEditSheet {
        TextFieldView(vm: vm, editMode: vm.editMode, ieEditMode: true)
      }
    } // END: Zstack

  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.locale, Locale(identifier: "ja-jp"))
  }
}
