//
//  FontSizeSelectionView.swift
//  TTextRitchEditor
//
//  Created by MichelleRaouf on 22/06/2024.
//

import SwiftUI

struct FontSizeSelectionView: View {
    @Binding var selectedFontSize: ENUMFontSize
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Select a Font Size")
                .font(.headline)
                .padding()

            ForEach([ENUMFontSize.small, .normal, .medium, .large, .xlarge], id: \.self) { size in
                Button(action: {
                    selectedFontSize = size
                    isPresented = false
                }) {
                    Text("\(size.rawValue, specifier: "%.0f") pt")
                        .font(.system(size: size.rawValue))
                        .padding()
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }
}


#Preview {
    FontSizeSelectionView(selectedFontSize:  .constant(ENUMFontSize.normal), isPresented: .constant(true))
}
