//
//  CameraView.swift
//  TodoList
//
//  Created by Kaori Persson on 2022-12-21.
//

import SwiftUI

struct CameraView: View {
  
  @ObservedObject var viewModel : CameraViewModel
  
  @Binding var imageData : Data
  @Binding var source:UIImagePickerController.SourceType
  
  @Binding var image:Image
  
  @Binding var isActionSheet:Bool
  @Binding var isImagePicker:Bool
  
  var body: some View {
    
    VStack(spacing:0){
      ZStack{
        NavigationLink(
          destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
          isActive:$isImagePicker,
          label: {
            Text("")
          })
        VStack{
          HStack(spacing:30){
            Text("photo")
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 60, height: 60)
              .cornerRadius(10)
            Button(action: {
              self.source = .photoLibrary
              self.isImagePicker.toggle()
            }, label: {
              Text("Upload")
            })
            Button(action: {
              self.source = .camera
              self.isImagePicker.toggle()
            }, label: {
              Text("Take Photo")
            })
            Spacer()
          }
          .padding()
        }
      }
    }
    .onAppear(){
      loadImage()
    }
    .navigationBarTitle("Add Todo", displayMode: .inline)
  }
  
  func loadImage() {
    if imageData.count != 0{
      viewModel.imageData = imageData
      self.image = Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
    }else{
      self.image = Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
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
      let data = image.pngData()
      
      self.parent.image = data!
      self.parent.show.toggle()
    }
  }
}
