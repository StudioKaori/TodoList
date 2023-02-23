//
//  HomeView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject var vm: HomeViewModel
  @State private var isShowingTodoInputField = false

  var body: some View {
    ZStack(alignment: .bottom) {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        Text("Todos")
          .font(.headline)
          .padding(.top, 60)
          .padding(.bottom, 30)
        
        HorizontalListsView()
        
        TodoListView()
          .padding(.bottom, 60)
      } // END: Vstack Main container
      
      BottomMenuView(isShowingTodoInputField: $isShowingTodoInputField)
      
      if vm.showingEditSheet {
        switch(vm.editMode) {
        case .todo:
          EditTodoView()
        case .list:
          EditListNameView()
        }
      }
      
      if isShowingTodoInputField {
        AddTodoView(isShowingTodoInputField: $isShowingTodoInputField)
      }
    } // END: Zstack
    .ignoresSafeArea()
    .overlay(overlayView: ToastView(toast: Toast(title: vm.toastText, iconName: vm.toastIconName), show: $vm.showToast), show: $vm.showToast)
  }

}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.locale, Locale(identifier: "ja-jp"))
  }
}
