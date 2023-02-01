//
//  TodoDescriptionView.swift
//  TodoList
//
//  Created by Kaori Persson on 2023-01-30.
//

import SwiftUI

struct TodoDescriptionView: View {
  @Binding var todoDescription: String
  @Binding var showDescriptionSheet: Bool
  
  var body: some View {
    VStack {
      
      List{
        Section(header: Text("Todo Description")) {
          TextEditor(text: $todoDescription)
            .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
        
      }
      
      HStack(spacing: 18) {
        Button {
          showDescriptionSheet = false
        } label: {
          HStack(spacing: 0) {
            Image(systemName: "checkmark.circle")
            Text("Close")
          }
        }
        
      } // END: Fotter Hstack
    }
  }
}

struct TodoDescriptionView_Previews: PreviewProvider {
  static var previews: some View {
    TodoDescriptionView(todoDescription: .constant("My todo description"),
                        showDescriptionSheet: .constant(true))
  }
}
