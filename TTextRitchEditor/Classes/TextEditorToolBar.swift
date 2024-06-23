//
//  TextEditorToolBar.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import SwiftUI

public struct TextEditorToolBar: View {
    @EnvironmentObject var viewModel: TextEditorViewModel
    var style: TextEditorTabBarStyle
    
    init(style: TextEditorTabBarStyle ) {
        self.style = style
    }
    
  public  var body: some View {
            DynamicGrid(
                style: style ,
                items: ["text.alignleft", "text.aligncenter", "text.alignright" ,"bold", "italic", "underline" , "strikethrough", "textformat.size", "textformat.superscript" , "textformat.subscript",
                                "paintpalette" , "paintbrush",
                        "photo.artframe" , "video.fill"
                               // "list.bullet"
                                
                               
                       ]).environmentObject(viewModel)
        // Example items
            .frame(maxWidth: .infinity)
            
            // Additional content of the TextEditorToolBar
      
    }
}
#Preview {
    TextEditorToolBar(style: TextEditorTabBarStyle()).environmentObject(TextEditorViewModel(data: nil))
}



struct DynamicGrid: View {
    @EnvironmentObject var viewModel: TextEditorViewModel

    let style: TextEditorTabBarStyle
    let items: [String]
    let spacing: CGFloat = 25
    let iconSize: CGFloat = 30
    

    

    @State private var isFontSizeDialogShown = false
    @State private var isShowingImagePicker = false
    @State private var isShowingVideoPicker = false



    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            let rows = generateRows(items: items, availableWidth: UIScreen.main.bounds.width, iconSize: iconSize, spacing: spacing)
            ForEach(rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            switch item {
                            case "text.alignleft":
                                viewModel.textAlign = NSTextAlignment.left
                            case "text.aligncenter":
                                viewModel.textAlign = NSTextAlignment.center
                            case "text.alignright":
                                viewModel.textAlign = NSTextAlignment.right
                            case "bold":
                                viewModel.applyBold.toggle()
                            case "italic":
                                viewModel.applyItalic.toggle()
                            case "underline":
                                viewModel.applyUnderline.toggle()
                            case "strikethrough":
                                viewModel.applyStrikethrough.toggle()
                            case "textformat.size":
                                isFontSizeDialogShown.toggle()
                                break
                            case "textformat.superscript":
                                if(viewModel.textPosition == .SUPERSCRIPT){
                                    viewModel.textPosition = .NORMAL
                                } else {
                                    viewModel.textPosition = .SUPERSCRIPT
                                }
                                break
                            case "textformat.subscript":
                                if(viewModel.textPosition == .SUBSCRIPT){
                                    viewModel.textPosition = .NORMAL
                                } else {
                                    viewModel.textPosition = .SUBSCRIPT
                                }
                                break
                            case "list.bullet":
                                viewModel.isBulletedListActive.toggle()
                                
                            case "paintbrush":
                                viewModel.showBGColor.toggle()
                            case "paintpalette":
                                viewModel.showTextColor.toggle()
                            case "photo.artframe":
                               
                                isShowingImagePicker.toggle()
                                break
                            case "video.fill":
                                isShowingVideoPicker.toggle()
                            default:
                                break
                            }
                        }) {
                            ZStack {
                                    Image(systemName: item)
                                        .resizable()
                                        .padding(6)

                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: iconSize, height: iconSize)
                                        .foregroundColor(getIconColor(item))
                                        .background(getBackgroundColor(item))
                                        .cornerRadius(10)
                                       
                                        .overlay( /// apply a rounded border
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.gray.opacity(0.1), lineWidth: 5)
                                        )
                            }
                        }.padding(.vertical)
                    }
                }
            }
           
        }.sheet(isPresented: $isFontSizeDialogShown, content: {
            FontSizeSelectionView(selectedFontSize: $viewModel.fontSize, isPresented: $isFontSizeDialogShown)
        }).sheet(isPresented: $isShowingImagePicker) {
            ImageOrVideoPickerView(isShown: self.$isShowingImagePicker , selectedMediaData: $viewModel.imageOrVideo , selectedMediaType: $viewModel.mediaType , mediaTypeFilter: .image)
        }.sheet(isPresented: $isShowingVideoPicker) {
                ImageOrVideoPickerView(isShown: self.$isShowingVideoPicker , selectedMediaData: $viewModel.imageOrVideo , selectedMediaType: $viewModel.mediaType , mediaTypeFilter: .video
                )}
        .padding()
    }
    
    
    
    private func getIconColor(_ item: String) -> Color{
        switch item {
        case "text.alignleft":
            if(viewModel.textAlign == .left){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "text.aligncenter":
            if(viewModel.textAlign == .center){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "text.alignright":
            if(viewModel.textAlign == .right){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "bold":
            if(viewModel.applyBold){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "italic":
            if(viewModel.applyItalic){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "underline":
            if(viewModel.applyUnderline){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "strikethrough":
            if(viewModel.applyStrikethrough){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "textformat.superscript":
            if(viewModel.textPosition == .SUPERSCRIPT){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
        case "textformat.subscript":
            if(viewModel.textPosition == .SUBSCRIPT){
                return style.iconActiveColor
            }else{
                return style.iconUnActiveColor
            }
            
        case "paintbrush":
            return viewModel.bgColor
        case "paintpalette":
            return viewModel.textColor.opacity(0.5)
        default:
            return style.iconUnActiveColor
        }
    }
    
   
    private func getBackgroundColor(_ item: String) -> Color{
        switch item {
        case "text.alignleft":
            if(viewModel.textAlign == .left){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "text.aligncenter":
            if(viewModel.textAlign == .center){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "text.alignright":
            if(viewModel.textAlign == .right){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "bold":
            if(viewModel.applyBold){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "italic":
            if(viewModel.applyItalic){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "underline":
            if(viewModel.applyUnderline){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "strikethrough":
            if(viewModel.applyStrikethrough){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "textformat.superscript":
            if(viewModel.textPosition == .SUPERSCRIPT){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        case "textformat.subscript":
            if(viewModel.textPosition == .SUBSCRIPT){
                return style.iconActiveBGColor
            }else{
                return style.iconUnActiveBGColor
            }
        default:
            return style.iconUnActiveBGColor
        }
    }
    
   
    private func generateRows(items: [String], availableWidth: CGFloat, iconSize: CGFloat, spacing: CGFloat) -> [[String]] {
        var rows: [[String]] = [[]]
        var currentWidth: CGFloat = 0

        for item in items {
            let itemWidth = iconSize + spacing
            if currentWidth + itemWidth > availableWidth {
                rows.append([])
                currentWidth = 0
            }
            rows[rows.count - 1].append(item)
            currentWidth += itemWidth
        }

        return rows
    }

}



