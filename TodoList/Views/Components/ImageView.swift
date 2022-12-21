//
//  ImageView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-21.
//

import SwiftUI
import CoreData

struct ImageView: View {
  
  init() {
    UITextView.appearance().backgroundColor = .clear
  }
  
  @StateObject var viewModel = CameraViewModel()
  @StateObject var todoDataManager = TodoDataManager.shared
  //@FetchRequest(entity: TodoEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "addedDate", ascending: true)],animation: .spring()) var todoDataManager.savedTodos : FetchedtodoDataManager.savedTodos<Task>
  var context = PersistenceController.shared.container.viewContext
  
  var body: some View {
    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
      NavigationView{
        VStack(spacing:0){
          if todoDataManager.savedTodos.count == 0{
            Spacer()
            Text("No Tasks")
              .font(.title)
              .foregroundColor(.primary)
              .fontWeight(.heavy)
            Spacer()
          }else{
            
            ScrollView(.vertical,showsIndicators: false, content:{
              LazyVStack(alignment: .leading, spacing: 20){
                ForEach(todoDataManager.savedTodos) {task in
                  VStack(alignment: .leading, spacing: 5, content: {
                    HStack{
                      if task.image?.count ?? 0 != 0{
                        Image(uiImage: UIImage(data: task.image ?? Data.init())!)
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 80, height: 80)
                          .cornerRadius(10)
                      }
                      VStack{
                        Text(task.addedDate ?? Date(),style: .date)
                          .fontWeight(.bold)
                      }
                    }
                    .padding(.horizontal)
                    
                    Text(task.title ?? "")
                      .font(.title)
                      .fontWeight(.bold)
                      .padding(.horizontal)
                    Divider()
                  })
                  .foregroundColor(.primary)
                  .contextMenu{
                    Button(action: {
                      viewModel.EditItem(item: task)
                    }, label: {
                      Text("Edit")
                    })
                    Button(action: {
                      context.delete(task)
                      try! context.save()
                    }, label: {
                      Text("Delete")
                    })
                  }
                }
              }
              .padding()
            })
          }
        }
        .navigationBarTitle("Home", displayMode: .inline)
      }
      Button(action: {viewModel.isNewData.toggle()}, label: {
        Image(systemName: "plus")
          .font(.largeTitle)
          .foregroundColor(.white)
          .padding(20)
          .background(Color.green)
          .clipShape(Circle())
          .padding()
      })
    })
    .ignoresSafeArea(.all, edges: .top)
    .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .all))
    .sheet(isPresented: $viewModel.isNewData,
           onDismiss:{
      viewModelValueReset()
    },
           content: {
      NewDataSheet(viewModel: viewModel)
    })
  }
  
  func viewModelValueReset(){
    viewModel.updateItem = nil
    viewModel.content = ""
    viewModel.date = Date()
    viewModel.priority = 0
    viewModel.imageData = Data.init()
  }
}

