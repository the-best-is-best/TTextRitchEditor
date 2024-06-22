//
//  TextEditorTabBarStyle.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation
import SwiftUI

public struct TextEditorTabBarStyle {
    var iconActiveColor: Color = .white
    var iconActiveBGColor:Color = .teal
    
    var iconUnActiveColor: Color = .black
    var iconUnActiveBGColor: Color = .white
    
    public init(iconActiveColor: Color = .white, iconActiveBGColor: Color = .teal, iconUnActiveColor: Color = .black, iconUnActiveBGColor: Color = .white) {
        self.iconActiveColor = iconActiveColor
        self.iconActiveBGColor = iconActiveBGColor
        self.iconUnActiveColor = iconUnActiveColor
        self.iconUnActiveBGColor = iconUnActiveBGColor
    }
}
