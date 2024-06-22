//
//  ExtFont.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation
import SwiftUI

extension UIFont {
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    var isUnderLine:Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
   
}
