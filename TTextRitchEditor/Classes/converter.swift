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
    } else if isVideoData(data) {
        return (data, .video)
    } else {
        return (nil, .unknown)
    }
}

private func isVideoData(_ data: Data) -> Bool {
    do {
        // Create a temporary file URL
        let temporaryFileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp4")
        
        // Write the data to the temporary file
        try data.write(to: temporaryFileURL)
        
        // Attempt to create an AVAsset from the temporary file URL
        let asset = AVAsset(url: temporaryFileURL)
        
        // Check if AVAsset is successfully created
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            return false // No video track found
        }
        
        // Check if the track has video dimensions (optional check)
        let hasVideoDimensions = videoTrack.naturalSize.width > 0 && videoTrack.naturalSize.height > 0
        
        // Optionally, you can check additional criteria here (e.g., duration, codec, etc.)
        
        return hasVideoDimensions
    } catch {
        print("Error writing data to temporary file or creating AVAsset: \(error)")
        return false
    }
}
