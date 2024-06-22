//
//  ColorPickerView.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Binding var isPickerVisible: Bool
    
    var body: some View {
        ZStack {
            
            HStack {
                ColorPicker("Color: ", selection: $selectedColor).frame(maxWidth: 100)
                  
                Spacer().frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).padding()
              
                
            Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .scaledToFit()
                    .onTapGesture {
                        isPickerVisible = false
                    }
              
            }.padding()
            .background(Color.white) // Make the background transparent
            .padding()
            .cornerRadius(10)
            .shadow(radius: 5
            )
        }
    }
}
