//
//  CameraView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-21.
//

import SwiftUI

struct AttachTodoImageView: View {
  
  @ObservedObject var todoDataManager = TodoDataManager.shared
  @State private var isShowingActionSheet = false
  
  @Binding var imageData : Data
  @Binding var source:UIImagePickerController.SourceType
  @Binding var image:Image
  @Binding var isImagePicker:Bool
  
  var body: some View {
    
    HStack(spacing: 0){
      
      if (UIImage(data: imageData) != nil) {
        
        Button {
          isShowingActionSheet = true
        } label: {
          Image(systemName: "photo")
            .font(.system(size: DefaultValues.editTodoIconSize))
            .foregroundColor(Color.theme.accent)
            .onAppear {
              if imageData.count != 0 {
                todoDataManager.imageData = imageData
              }
            }
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
          ActionSheet(title: Text("Delete the image"),
                      buttons: [
                        .destructive(Text("Delete"), action: {
                          imageData = Data()
                        }),
                        .cancel(Text("Cancel"))
                      ]
          )
        }
        
      } else {
        Button {
          isShowingActionSheet = true
        } label: {
          Image(systemName: "photo")
            .font(.system(size: DefaultValues.editTodoIconSize))
            .foregroundColor(Color.theme.primaryText)
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
          ActionSheet(title: Text("Attach image"),
                      message: Text(""),
                      buttons: [
                        .default(Text("Photo library"), action: {
                          self.source = .photoLibrary
                          self.isImagePicker.toggle()
                        }),
                        .default(Text("Camera"), action: {
                          self.source = .camera
                          self.isImagePicker.toggle()
                        }),
                        .cancel(Text("Cancel"))
                        
                      ])
        } // END: Actionsheet
        .sheet(isPresented: $isImagePicker) {
          Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source)
        }
        
      }
      
    }
  }
}

struct Imagepicker : UIViewControllerRepresentable {
  
  @Binding var show:Bool
  @Binding var image:Data
  
  var sourceType:UIImagePickerController.SourceType
  
  func makeCoordinator() -> Imagepicker.Coodinator {
    
    return Imagepicker.Coordinator(parent: self)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<Imagepicker>) -> UIImagePickerController {
    
    let controller = UIImagePickerController()
    controller.sourceType = sourceType
    controller.delegate = context.coordinator
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<Imagepicker>) {
  }
  
  class Coodinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var parent : Imagepicker
    
    init(parent : Imagepicker){
      self.parent = parent
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      self.parent.show.toggle()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      let image = info[.originalImage] as! UIImage
      // png doesn't save orientation date, use jpegdata instead
      let data = image.jpegData(compressionQuality: 1)
      
      self.parent.image = data!
      self.parent.show.toggle()
    }
  }
}
