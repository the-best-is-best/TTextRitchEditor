//
//  TextRitchEditorView.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 17/06/2024.
//

import SwiftUI

public struct TextRitchEditorView: View {
    let dataJson: String?
    @StateObject var viewModel: TextEditorViewModel
    var styleTextEditorBar: TextEditorTabBarStyle
    var generatedJson: Binding<String>
    
    public init(styleTextEditorBar: TextEditorTabBarStyle = TextEditorTabBarStyle(), dataJson: String? = nil, getNewValue: Binding<String>) {
        self.styleTextEditorBar = styleTextEditorBar
        self.dataJson = dataJson
        _viewModel = StateObject(wrappedValue: TextEditorViewModel(data: dataJson?.data(using: .utf8))) // Initialize with nil data initially
        self.generatedJson = getNewValue
    }
    
    public var body: some View {
        ZStack {
            VStack {
                TextEditorToolBar(style: styleTextEditorBar)
                    .environmentObject(viewModel)
                    .padding()
                
                RichTextEditor(attributedText: $viewModel.attributedText)
                    .environmentObject(viewModel).frame(height: UIScreen.main.bounds.height * 0.3)
                    .border(Color.gray)
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                
                if viewModel.mediaType == .image, let imageData = viewModel.imageOrVideo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } else if viewModel.mediaType == .video, let videoData = viewModel.imageOrVideo {
                    VideoPlayerView(videoData: videoData)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.white) // Ensure background color for the full height
            .onChange(of: viewModel.generatedJson) { newJson in
                self.generatedJson.wrappedValue = newJson ?? ""
            }
            
            // Color pickers remain unchanged
            if viewModel.showBGColor {
                ColorPickerView(selectedColor: $viewModel.bgColor, isPickerVisible: $viewModel.showBGColor)
                    .background(Color.clear)
                    .padding(.horizontal, 50)
            }
            
            if viewModel.showTextColor {
                ColorPickerView(selectedColor: $viewModel.textColor, isPickerVisible: $viewModel.showTextColor)
                    .background(Color.clear)
                    .padding(.horizontal, 50)
            }
        }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
    }
}
#Preview {
    TextRitchEditorView(styleTextEditorBar: TextEditorTabBarStyle(), dataJson: nil, getNewValue: .constant(""))
}
