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
    df.locale = Locale(identifier: localeId)
    df.dateFormat = "E yyyy-MM-dd HH:mm"
    return df.string(from: date)
  }
}
