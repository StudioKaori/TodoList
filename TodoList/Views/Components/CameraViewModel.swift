//
//  CameraViewModel.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-21.
//

import SwiftUI
import CoreData

class CameraViewModel : ObservableObject{
  @Published var content = ""
  @Published var date = Date()
  @Published var priority = 0
  @Published var imageData:Data = Data.init()
  
  @Published var isNewData = false
  @Published var updateItem : TodoEntity!
  
  func writeData(context : NSManagedObjectContext ){
    
    if updateItem != nil{
      updateItem.addedDate = date
      updateItem.title = content
      updateItem.listId = defaultActiveListId
      //updateItem.priority = Int16(priority)
      updateItem.image = imageData
      
      try! context.save()
      
      updateItem = nil
      isNewData.toggle()
      content = ""
      date = Date()
      priority = 0
      imageData = Data.init()
      return
    }
    
    let newTask = TodoEntity(context: context)
    newTask.addedDate = date
    newTask.title = content
    newTask.listId = defaultActiveListId
    //newTask.priority = Int16(priority)
    newTask.image = imageData
    
    
    do{
      try context.save()
      isNewData.toggle()
      
      content = ""
      date = Date()
      priority = 0
      imageData = Data.init()
    }
    catch{
      print(error.localizedDescription)
    }
  }
  
  func EditItem(item: TodoEntity){
    updateItem = item
    
    date = item.addedDate!
    content = item.title!
    //priority = Int(item.priority)
    imageData = item.image ?? Data.init()
    
    isNewData.toggle()
  }
}

