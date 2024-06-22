//
//  ImageOrVideoPickerView.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import SwiftUI
import UIKit
import AVFoundation
import UniformTypeIdentifiers

struct ImageOrVideoPickerView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var selectedMediaData: Data?
    @Binding var selectedMediaType: MediaType
    var mediaTypeFilter: MediaType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var selectedMediaData: Data?
        @Binding var selectedMediaType: MediaType

        init(isShown: Binding<Bool>, selectedMediaData: Binding<Data?>, selectedMediaType: Binding<MediaType>) {
            _isShown = isShown
            _selectedMediaData = selectedMediaData
            _selectedMediaType = selectedMediaType
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let mediaType = info[.mediaType] as? String {
                if mediaType == UTType.image.identifier {
                    if let uiImage = info[.originalImage] as? UIImage, let imageData = uiImage.jpegData(compressionQuality: 1.0) {
                        selectedMediaData = imageData
                        selectedMediaType = .image
                    }
                } else if mediaType == UTType.movie.identifier {
                    if let mediaURL = info[.mediaURL] as? URL, let videoData = try? Data(contentsOf: mediaURL) {
                        selectedMediaData = videoData
                        selectedMediaType = .video
                    }
                }
            }
            isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, selectedMediaData: $selectedMediaData, selectedMediaType: $selectedMediaType)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = mediaTypeFilter == .image ? [UTType.image.identifier] : [UTType.movie.identifier]
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update UI
    }
}
