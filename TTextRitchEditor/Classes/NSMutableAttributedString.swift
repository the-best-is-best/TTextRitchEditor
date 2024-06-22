//
//  NSMutableAttributedString.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
  public  func convertToHTML() -> String? {
            do {
                // Convert the attributed string to HTML data
                let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                let htmlData = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes: documentAttributes)
                
                // Convert HTML data to string
                guard var htmlString = String(data: htmlData, encoding: .utf8) else {
                    print("Failed to convert attributed string to HTML string: Encoding issue")
                    return nil
                }
                
                // Transform the HTML string to replace spans with vertical-align
                htmlString = transformHTML(htmlString)
                
                // Return the modified HTML string
                return htmlString
            } catch {
                print("Error converting attributed string to HTML: \(error.localizedDescription)")
                return nil
            }
        }
        
    private func transformHTML(_ htmlString: String) -> String {
        var modifiedHTML = htmlString
        
        do {
            // Step 1: Extract CSS styles and apply them as inline styles
            if let styleRange = modifiedHTML.range(of: "(?s)<style.*?</style>", options: .regularExpression) {
                let styleContent = String(modifiedHTML[styleRange])
                var cssStyles = [String: String]()
                
                // Extract class names and their corresponding styles
                let cssRegex = try NSRegularExpression(pattern: "\\.(\\w+)\\s*\\{([^}]*)\\}", options: [])
                let matches = cssRegex.matches(in: styleContent, options: [], range: NSRange(location: 0, length: styleContent.utf16.count))
                
                for match in matches {
                    if match.numberOfRanges == 3,
                       let classNameRange = Range(match.range(at: 1), in: styleContent),
                       let stylesRange = Range(match.range(at: 2), in: styleContent) {
                        let className = String(styleContent[classNameRange])
                        let styles = String(styleContent[stylesRange])
                        cssStyles[className] = styles
                    }
                }
                
                // Remove the <style> block from HTML
                modifiedHTML.removeSubrange(styleRange)
                
                // Apply inline styles
                for (className, styles) in cssStyles {
                    let classRegex = try NSRegularExpression(pattern: "class=\"[^\"]*\\b\(className)\\b[^\"]*\"", options: [])
                    let classMatches = classRegex.matches(in: modifiedHTML, options: [], range: NSRange(location: 0, length: modifiedHTML.utf16.count))
                    
                    for classMatch in classMatches.reversed() {
                        if let classRange = Range(classMatch.range, in: modifiedHTML) {
                            var classAttribute = String(modifiedHTML[classRange])
                            classAttribute = classAttribute.replacingOccurrences(of: "class=\"", with: "style=\"\(styles); ")
                            modifiedHTML.replaceSubrange(classRange, with: classAttribute)
                        }
                    }
                }
            }
            
            // Step 2: Transform <span> tags with vertical-align
            let spanRegex = try NSRegularExpression(pattern: "<span([^>]*)style=\"([^\"]*vertical-align: ([+-]?\\d+\\.\\d+)px[^\"]*)\"([^>]*)>(.*?)<\\/span>", options: [])
            let spanMatches = spanRegex.matches(in: modifiedHTML, options: [], range: NSRange(location: 0, length: modifiedHTML.utf16.count))
            
            for match in spanMatches.reversed() {
                if match.numberOfRanges == 6,
                   let attributesRange = Range(match.range(at: 1), in: modifiedHTML),
                   let verticalAlignRange = Range(match.range(at: 3), in: modifiedHTML),
                   let contentRange = Range(match.range(at: 5), in: modifiedHTML) {
                    
                    let verticalAlignValue = Double(modifiedHTML[verticalAlignRange]) ?? 0
                    let attributes = String(modifiedHTML[attributesRange])
                    let content = String(modifiedHTML[contentRange])
                    
                    let newTag: String
                    if verticalAlignValue < 0 {
                        newTag = "<sub\(attributes)>\(content)</sub>"
                    } else if verticalAlignValue > 0 {
                        newTag = "<sup\(attributes)>\(content)</sup>"
                    } else {
                        newTag = "<span\(attributes)>\(content)</span>"
                    }
                    
                    modifiedHTML.replaceSubrange(Range(match.range, in: modifiedHTML)!, with: newTag)
                }
            }
        } catch {
            print("Error processing HTML string: \(error.localizedDescription)")
        }
        
        return modifiedHTML
    }
           
           private func applyInlineStyles(to htmlString: String) -> String {
               // Remove the <style> tag and its content
               let styleTagPattern = "<style[^>]*>.*?</style>"
               let regex = try! NSRegularExpression(pattern: styleTagPattern, options: [.dotMatchesLineSeparators])
               let range = NSRange(location: 0, length: htmlString.utf16.count)
               let withoutStyleTag = regex.stringByReplacingMatches(in: htmlString, options: [], range: range, withTemplate: "")
               
               // Process the remaining HTML to ensure inline styles
               let updatedHtmlString = processHTML(withoutStyleTag)
               
               return updatedHtmlString
           }
           
           private func processHTML(_ htmlString: String) -> String {
               let pattern = "(<[^>]+) style=\"([^\"]*)\"([^>]*>)"
               let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
               let range = NSRange(location: 0, length: htmlString.utf16.count)
               let modifiedHtmlString = regex.stringByReplacingMatches(in: htmlString, options: [], range: range, withTemplate: "$1$2")
               
               return modifiedHtmlString
           }
       

      static func convertFromHTML(data: Data) -> NSMutableAttributedString? {
        do {
            // Convert HTML data to NSMutableAttributedString
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            
          
                    
            return attributedString
        } catch {
            print("Error converting HTML to attributed string: \(error)")
            return nil
        }
    }

}
