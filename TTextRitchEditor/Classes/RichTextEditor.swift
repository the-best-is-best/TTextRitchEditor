//
//  RichTextEditor.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 17/06/2024.
//

import SwiftUI

struct RichTextEditor: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var attributedText: NSMutableAttributedString
    @EnvironmentObject var viewModel: TextEditorViewModel
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        
        // Set initial attributed text
        textView.attributedText = attributedText
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let selectedRange = uiView.selectedRange
        uiView.attributedText = attributedText
        uiView.selectedRange = selectedRange
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
        
        init(parent: RichTextEditor) {
            self.parent = parent
        }
        
        func applyTextAttributes(_ selectedRange: NSRange, _ attributedString: NSMutableAttributedString) {
            let fontSize = parent.viewModel.fontSize.rawValue
            let range = NSRange(location: selectedRange.location - 1, length: 1)
            
            // Initialize the attributes dictionary
            var attributes: [NSAttributedString.Key: Any] = [:]
            
            // Combine font attributes (bold, italic)
            var fontDescriptor = UIFont.systemFont(ofSize: fontSize).fontDescriptor
            if parent.viewModel.applyBold {
                fontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor
            }
            if parent.viewModel.applyItalic {
                fontDescriptor = fontDescriptor.withSymbolicTraits(.traitItalic) ?? fontDescriptor
            }
            let combinedFont = UIFont(descriptor: fontDescriptor, size: fontSize)
            attributes[.font] = combinedFont
            
            // Apply underline if needed
            if parent.viewModel.applyUnderline {
                attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            } else {
                attributedString.removeAttribute(.underlineStyle, range: range)
            }
            
            // Apply strikethrough if needed
            if parent.viewModel.applyStrikethrough {
                attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            } else {
                attributedString.removeAttribute(.strikethroughStyle, range: range)
            }
            
            // Apply text position
            switch parent.viewModel.textPosition {
            case .SUPERSCRIPT:
                attributes[.baselineOffset] = fontSize * 0.5 // Adjust the multiplier as needed
            case .SUBSCRIPT:
                attributes[.baselineOffset] = -fontSize * 0.5 // Adjust the multiplier as needed
            case .NORMAL:
                attributes[.baselineOffset] = 0 // Reset baseline offset
            }
            
            // Apply text color and background color attributes
            attributes[.foregroundColor] = UIColor(parent.viewModel.textColor)
            attributes[.backgroundColor] = UIColor(parent.viewModel.bgColor)
            
            // Apply the combined attributes
            attributedString.addAttributes(attributes, range: range)
        }
        
        func textAlign(_ selectedRange: NSRange, _ attributedString: NSMutableAttributedString, _ textView: UITextView) {
            let range = NSRange(location: selectedRange.location - 1, length: 1)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = parent.viewModel.textAlign
            
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            
            // Restore cursor position after applying alignment
            let newSelectedRange = NSRange(location: selectedRange.location, length: 0)
            textView.selectedRange = newSelectedRange
        }
        
        func bulletList(_ textView: UITextView, _ attributedString: NSMutableAttributedString) {
            if parent.viewModel.isBulletedListActive {
                var moveCursor = false
                let selectedRange = textView.selectedRange
                
                if selectedRange.location > 0 {
                    let previousCharRange = NSRange(location: selectedRange.location - 1, length: 1)
                    let previousChar = attributedString.attributedSubstring(from: previousCharRange).string
                    
                    if previousChar.contains("\n") {
                        // Determine the prefix of the current line
                        let bulletFontSize: CGFloat = parent.viewModel.fontSize.rawValue // Adjust as needed
                        let bulletAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: bulletFontSize),
                            .foregroundColor: UIColor.black // Example color
                        ]
                        
                        // Create attributed string for the bullet point
                        let bulletPoint: String = "\u{2022}" // Unicode character for bullet (•)
                        let bulletAttributedString = NSAttributedString(string: "\n\(bulletPoint) ", attributes: bulletAttributes)
                        
                        // Replace characters with bullet point and attributes
                        attributedString.replaceCharacters(in: previousCharRange, with: bulletAttributedString)
                        textView.attributedText = attributedString
                        
                        // Move cursor one character forward
                        textView.selectedRange = NSRange(location: selectedRange.location + 1, length: 0)
                        
                        moveCursor = true
                    }
                }
                
                if moveCursor {
                    let newPosition = textView.selectedRange.location + 1
                    let range = NSRange(location: newPosition, length: 0)
                    textView.selectedRange = range
                }
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let selectedRange = textView.selectedRange
            let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
            
            applyTextAttributes(selectedRange, attributedString)
            textAlign(selectedRange, attributedString, textView)
            bulletList(textView, attributedString)
            parent.attributedText = attributedString
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Check if trying to delete the first character
            if text.isEmpty && range.length == 1 && range.location == 0 {
                // Convert to plain text for manipulation
                let plainText = parent.attributedText.string
                
                // Manipulate the plain text (remove first character)
                let modifiedText = String(plainText.dropFirst())
                
                // Convert back to NSMutableAttributedString with attributes
                let modifiedAttributedString = NSMutableAttributedString(string: modifiedText)
                // Apply necessary attributes from parent.viewModel or as needed
                
                // Update parent's attributedText and UITextView's attributedText
                parent.attributedText = modifiedAttributedString
                textView.attributedText = modifiedAttributedString
                
                // Return false to prevent default text changing behavior
                return false
            }
            
            return true
        }
    }
}
