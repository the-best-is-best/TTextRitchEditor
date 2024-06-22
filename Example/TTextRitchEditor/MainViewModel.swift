//
//  MainViewModel.swift
//  TTextRitchEditor_Example
//
//  Created by MichelleRaouf on 22/06/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
class MainContentViewModel: ObservableObject {
    @Published var newValue: String = ""

    init() {
        loadJSONData()
    }
    
    
    func loadJSONData() {
            guard let fileUrl = Bundle.main.url(forResource: "example", withExtension: "json") else {
                print("File not found")
                return
            }
            
            do {
                let jsonData = try Data(contentsOf: fileUrl)
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    print("Couldn't convert data to string")
                    return
                }
                
                DispatchQueue.main.async {
                    self.newValue = jsonString
//                    self.loading = false
                }
            } catch {
                print("Error reading JSON file: \(error)")
            }
        }

}
