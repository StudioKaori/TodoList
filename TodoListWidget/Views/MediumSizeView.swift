//
//  MediumSizeView.swift
//  TodoListWidgetExtension
//
//  Created by Kaori Persson on 2022-12-14.
//

import WidgetKit
import SwiftUI

struct MediumSizeView: View {
  var entry: SimpleEntry
  
    var body: some View {
      Text(entry.date, style: .time)
      Text(entry.title)
    }
}
