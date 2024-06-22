//
//  MainContent.swift
//  TTextRitchEditor_Example
//
//  Created by MichelleRaouf on 22/06/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import TTextRitchEditor


func loadJSONData() -> String? {
    guard let fileUrl = Bundle.main.url(forResource: "example", withExtension: "json") else {
        print("File not found")
        return nil
    }
    
    do {
        let jsonData = try Data(contentsOf: fileUrl)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Couldn't convert data to string")
            return nil
        }
        
        return jsonString
    } catch {
        print("Error reading JSON file: \(error)")
        return nil
    }
}

struct MainContent: View {
   
    
    @StateObject var viewModel: MainContentViewModel = MainContentViewModel()
   
    var body: some View {
        VStack{
            ScrollView {
                VStack {
                    TextRitchEditorView(styleTextEditorBar: TextEditorTabBarStyle(), dataJson: loadJSONData(), getNewValue: $viewModel.newValue)
                    
                        .onChange(of: viewModel.newValue) { _ in
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
