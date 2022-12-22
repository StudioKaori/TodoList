//
//  DateFormatter.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-22.
//

import Foundation

class LocalisedDateFormatter {
  
  static func getFormattedDate(date: Date) -> String {
    let locale = Locale.current
    let localeId = locale.identifier

    let df = DateFormatter()
    //df.locale = Locale(identifier: localeId)
    switch(String(localeId.prefix(2))) {
    case "ja":
      df.dateFormat = "MM/dd E HH:mm"
    default:
      df.dateFormat = "E dd MMM HH:mm"
    }
    return df.string(from: date)
  }
}
