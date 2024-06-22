//
//  QuillParser.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import Foundation

struct QuillParser: Codable {
    let type: QuillType
    let value: String?

    init(type: QuillType, value: String? = nil) {
        self.type = type
        self.value = value
    }
}
