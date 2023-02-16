//
//  HomeView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject var vm: HomeViewModel

  var body: some View {
    ZStack {
      
      Color.theme.background
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        Text("Todos")
          .font(.headline)
          .padding(.bottom, 30)
        
        HorizontalListsView()
        
        TodoListView()
        
        Spacer()
        
        TodoInputFieldsView(isEditMode: false)
      } // END: Vstack Main container
      
      if vm.showingEditSheet {
        EditTodoView()
      }
    } // END: Zstack
    .overlay(overlayView: ToastView(toast: Toast(title: vm.toastText, iconName: vm.toastIconName), show: $vm.showToast), show: $vm.showToast)
  }

}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.locale, Locale(identifier: "ja-jp"))
  }
}
