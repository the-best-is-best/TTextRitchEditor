//
//  MainContent.swift
//  TTextRitchEditor_Example
//
//  Created by MichelleRaouf on 22/06/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import TTextRitchEditor

struct MainContent: View {
    @State var newValue: String = ""
    
    var body: some View {
        VStack{
            ScrollView {
                VStack {
                    TextRitchEditorView(styleTextEditorBar: TextEditorTabBarStyle(), getNewValue: $newValue)
                        .onChange(of: newValue) { _ in
                            //                        print("new json is \(newValue)")
                        }
                }
            }
        }
    }
}

#Preview {
    MainContent()
}
