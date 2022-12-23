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
        
        Button {
          sendNotificationRequest()
        } label: {
          Text("NOTIFICATION")
        }
        .padding(.bottom, 20)
        
        HorizontalListsView()
        
        TodoListView()
        
        Spacer()
        
        AddNewTodoView()
      } // END: Vstack Main container
      
      if vm.showingEditSheet {
        TextFieldView(editMode: vm.editMode, ieEditMode: true)
      }
    } // END: Zstack
  }
  
  func sendNotificationRequest(){
    let content = UNMutableNotificationContent()
    content.title = "通知のタイトル"
    content.body = "通知の内容です"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString , content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.locale, Locale(identifier: "ja-jp"))
  }
}
