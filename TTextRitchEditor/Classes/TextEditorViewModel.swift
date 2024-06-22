//
//  TextEditorViewModel.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation
import SwiftUI

public class TextEditorViewModel: ObservableObject {
    @Published var attributedText = NSMutableAttributedString() {
         didSet {
             updateJson()
         }
     }
     @Published var mediaType: MediaType = .unknown {
         didSet {
             updateJson()
         }
     }
     @Published var imageOrVideo: Data? = nil {
         didSet {
             updateJson()
         }
     }
    
    @Published var textAlign = NSTextAlignment.left
    @Published var applyBold = false
    @Published var applyItalic = false
    @Published var applyUnderline = false
    @Published var applyStrikethrough = false
    @Published var fontSize = ENUMFontSize.normal
    @Published var textPosition: TextPosition = .NORMAL
    @Published var isBulletedListActive: Bool = false
    @Published var showBGColor = false
    @Published var showTextColor = false
    @Published var textColor: Color = .black
    @Published var bgColor: Color = .white
    
    
    @Published var generatedJson: String? = nil

  public  init(data: Data?) {
        if let jsonData = data {
            DispatchQueue.main.async {
                self.initData(data: jsonData)
            }
        }
    }
    
  private  func initData(data: Data) {
        do {
            let quillParsers = try JSONDecoder().decode([QuillParser].self, from: data)
            
            if let textParser = quillParsers.first(where: { $0.type == .TEXT }), let textValue = textParser.value {
                if let htmlData = textValue.data(using: .utf8) {
                    if let attributedString = NSMutableAttributedString.convertFromHTML(data: htmlData) {
                        attributedText = attributedString
                    } else {
                        print("Failed to convert HTML to attributed string")
                    }
                } else {
                    print("Failed to convert string to data")
                }
            } else {
                print("No text content found in JSON")
            }
            
            if let textParser = quillParsers.first(where: { $0.type == .IMAGE }), let textValue = textParser.value {
                let data = convertBase64ToMediaData(textValue)
                imageOrVideo = data.0
                mediaType = data.1
            }
            
            if let textParser = quillParsers.first(where: { $0.type == .VIDEO }), let textValue = textParser.value {
                let data = convertBase64ToMediaData(textValue)
                imageOrVideo = data.0
                mediaType = data.1
            }
        } catch {
            print("Error reading or parsing JSON file: \(error)")
        }
    }
    private func updateJson() {
           DispatchQueue.main.async {
               // Convert attributedText to HTML
               if let htmlString = self.attributedText.convertToHTML() {
                   var quillParser: [QuillParser] = [
                       QuillParser(type: .TEXT, value: htmlString)
                   ]
                   switch self.mediaType {
                   case .image:
                       quillParser.insert(
                           QuillParser(
                               type: .IMAGE, value: convertImageToBase64(self.imageOrVideo)
                           ),
                           at: 1
                       )
                   case .video:
                       quillParser.insert(
                           QuillParser(
                               type: .VIDEO, value: convertImageToBase64(self.imageOrVideo)
                           ),
                           at: 1
                       )
                   case .unknown:
                       break
                   }
                   if let jsonData = try? JSONEncoder().encode(quillParser),
                      let jsonString = String(data: jsonData, encoding: .utf8) {
                       self.generatedJson = jsonString
                   }
               }
           }
       }
   }
