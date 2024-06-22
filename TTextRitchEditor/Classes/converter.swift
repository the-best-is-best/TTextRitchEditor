//
//  converter.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation
import SwiftUI
import AVFoundation


func convertMediaToBase64(_ mediaData: Data, mediaType: MediaType) -> String? {
   switch mediaType {
   case .image:
       return convertImageToBase64(mediaData)
   case .video:
       return convertVideoToBase64(mediaData)
   case .unknown:
       return nil
   }
}

// Helper functions

func convertImageToBase64(_ imageData: Data?) -> String? {
   return imageData?.base64EncodedString()
}

func convertVideoToBase64(_ videoData: Data?) -> String? {
   return videoData?.base64EncodedString()
}





private  func convertBase64ToData(_ base64String: String) -> Data? {
   guard let data = Data(base64Encoded: base64String) else {
       return nil
   }
   return data
}

func convertBase64ToMediaData(_ base64String: String) -> (Data?, MediaType) {
   guard let data = convertBase64ToData(base64String) else {
       return (nil, .unknown)
   }
   
   // Check if the data represents an image or video
    if UIImage(data: data) != nil {
       return (data, .image)
   } else if let _ = try? AVAsset(url: URL(dataRepresentation: data, relativeTo: nil)!) {
       return (data, .video)
   } else {
       return (nil, .unknown)
   }
}


extension AVAsset {
   var isVideo: Bool {
       return tracks(withMediaType: .video).count > 0
   }
}
