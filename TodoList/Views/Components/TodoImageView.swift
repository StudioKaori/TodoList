//
//  TodoImageView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-22.
//

import SwiftUI

struct TodoImageView: View {
  let imageId: String
  let navigationbarTitle: String
  @Binding var isShowingImageSheet: Bool
  
  var body: some View {
    VStack {
      Image(uiImage: UIImage(data: TodoDataManager.shared.todoImages[imageId] ?? Data.init())!)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .navigationBarTitle(navigationbarTitle, displayMode: .inline)
      
      Button {
        isShowingImageSheet.toggle()
      } label: {
        Image(systemName: "x.circle")
          .foregroundColor(Color.theme.primaryText)
          .font(.largeTitle)
      }
    }
    
  }
}

struct TodoImageView_Previews: PreviewProvider {
  static var previews: some View {
    TodoImageView(imageId: "", navigationbarTitle: "Title", isShowingImageSheet: .constant(true))
  }
}
