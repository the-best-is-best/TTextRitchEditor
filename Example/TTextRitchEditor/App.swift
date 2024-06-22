//
//  App.swift
//  TAdvTextField_Example
//
//  Created by 52ndSolution on 03/03/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI

@main
struct iOSApp: App {
   
    var body: some Scene {
    
        WindowGroup {
            MainView().environmentObject(MainViewModel())
        }
    }
}
