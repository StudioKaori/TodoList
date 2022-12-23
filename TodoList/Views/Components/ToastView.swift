//
//  ToastView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-23.
//

import SwiftUI

struct Toast {
  var title: String
  var image: String
}

struct ToastView: View {
  let toast: Toast
  
  @Binding var show: Bool
  
    var body: some View {
      VStack {
        Spacer()
        
        HStack {
          Image(systemName: toast.image)
          Text(toast.title)
        }
        .font(.headline)
        .foregroundColor(Color.theme.primaryText)
        .padding(.vertical, 20)
        .padding(.horizontal, 40)
        .background(.gray.opacity(0.4), in: Capsule())
      }
      .frame(width: UIScreen.main.bounds.width / 1.25)
      .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
      .onTapGesture {
        withAnimation {
          self.show = false
        }
      }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
      ToastView(toast: Toast(title: "test", image: "image"), show: .constant(true))
    }
}
