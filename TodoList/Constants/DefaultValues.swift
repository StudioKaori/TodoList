//
//  DefaultValues.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-20.
//

import Foundation

struct DefaultValues {
  // MARK: - Font sizes
  static let bulletSymbolFontSize: CGFloat = 8
  static let textBorderCornerRadius: CGFloat = 6

  // MARK: - Core data default values
  static let defaultActiveListId = "0"
  static let defaultWidgetListId = "0"
  static let todoDefaultIsDueDateActive = false
  static let todoDefaultIsDueDateDateOnly = true
  static let todoDefaultIsDueDateReminderOn = false

  // MARK: - User settings
  static let userSettingsDefaultReminderTime = "09:00"
}
