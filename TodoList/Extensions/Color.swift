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
  
}

struct BgColor: Identifiable {
  let id = UUID()
  let colorName: String
  let colorValue: Color
}

struct TodoBgTheme {
  
//  let colors: [BgColor] = [
//    BgColor(key: "red", value: Color("TodoBgRed")),
//    BgColor(key: "blue", value: Color("TodoBgBlue"))
//  ]
  
    let colors: [BgColor] = [
      BgColor(colorName: "none", colorValue: Color.theme.primaryText),
      BgColor(colorName: "red", colorValue: Color("TodoBgRed")),
      BgColor(colorName: "yellow", colorValue: Color("TodoBgYellow")),
      BgColor(colorName: "orange", colorValue: Color("TodoBgOrange")),
      BgColor(colorName: "blue", colorValue: Color("TodoBgBlue")),
      BgColor(colorName: "purple", colorValue: Color("TodoBgPurple"))
    ]
    
}
