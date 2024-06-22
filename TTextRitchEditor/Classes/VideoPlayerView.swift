//
//  VideoPlayerView.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoData: Data
    
    var body: some View {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        try? videoData.write(to: tempURL)
        
        return VideoPlayer(player: AVPlayer(url: tempURL))
    }
}

