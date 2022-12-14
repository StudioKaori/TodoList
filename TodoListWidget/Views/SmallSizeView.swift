//
//  SmallSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import SwiftUI

struct SmallSizeView: View {
  var entry: SimpleEntry
  
  var body: some View {
    
    VStack(alignment: .leading) {
      ForEach(entry.todos) { todo in
        Text(todo.title)
      }
    } // END: Vstack main container
  }
}

//struct SmallSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallSizeView()
//    }
//}
