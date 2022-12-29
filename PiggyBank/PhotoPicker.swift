//
//  PhotoPicker.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/27/22.
//

import SwiftUI
import PhotosUI
import Combine

struct PhotoPicker: View {
    @State private var image: Image?
    @State private var showPickingImage = false
    @Binding var inputSource: UIImage?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
           
            Button("Pick Image") {
                self.showPickingImage = true
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showPickingImage) {
                PhotoPickerViewContainer(image: $inputSource)
            }
            .onReceive(Just(inputSource)) { newImage in
                if let newImage {
                    self.image = Image(uiImage: newImage)
                }
            }
        }
    }
}

struct PhotoPickerViewContainer: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
        
        let parent: PhotoPickerViewContainer
        
        init(parent: PhotoPickerViewContainer) {
            self.parent = parent
        }

    }
}
