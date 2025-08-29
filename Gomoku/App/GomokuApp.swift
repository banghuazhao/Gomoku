//
// Created by Banghua Zhao on 25/08/2025
// Copyright Apps Bay Limited. All rights reserved.
//
  

import SwiftUI

@main
struct GomokuApp: App {
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(audioManager)
        }
    }
}
