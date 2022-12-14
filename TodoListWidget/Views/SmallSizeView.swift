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
      Text(entry.date, style: .time)
      Text(entry.title)
    }
}

//struct SmallSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallSizeView()
//    }
//}
