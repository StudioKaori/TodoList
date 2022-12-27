//
//  Color.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-13.
//

import Foundation
import SwiftUI

extension Color {
  static let theme = ColorTheme()
  static let todoBgTheme = TodoBgTheme()
}

struct ColorTheme {
  
  let accent = Color("AccentColor")
  
  let background = Color("BackgroundColor")
  let textFieldBackground = Color("TextFieldBackground")
  let listBackground = Color("ListBackgroundColor")
  
  let primaryText = Color("PrimaryTextColor")
  let secondaryText = Color("SecondaryTextColor")
  let warningText = Color("WarningTextColor")
  
}

struct BgColor: Identifiable {
  let id = UUID()
  let key: String
  let value: Color
}

struct TodoBgTheme {
  
  let colors: [BgColor] = [
    BgColor(key: "red", value: Color("TodoBgRed")),
    BgColor(key: "blue", value: Color("TodoBgBlue"))
  ]
  
}
