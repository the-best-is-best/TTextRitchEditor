//
//  ENUMFontSize.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation

import SwiftUI


enum ENUMFontSize: CGFloat, CaseIterable {
    case small = 15
    case normal = 20
    case medium = 25
    case large = 35
    case xlarge = 50
}


extension Font {
    static func toENUM(value: CGFloat) -> ENUMFontSize {
        switch value {
        case 15:
            return .small
        case 20:
            return .normal
        case 25:
            return .medium
        case 35:
            return .large
        case 50:
            return .xlarge
        default:
            return .normal
        }
    }
}
