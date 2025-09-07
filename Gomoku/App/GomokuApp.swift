//
// Created by Banghua Zhao on 25/08/2025
// Copyright Apps Bay Limited. All rights reserved.
//
  
import GoogleMobileAds
import SwiftUI

@main
struct GomokuApp: App {
    @StateObject private var audioManager = AudioManager.shared
    
    @StateObject private var openAd = OpenAd()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        MobileAds.shared.start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(audioManager)
                .onAppear {
                    AdManager.requestATTPermission(with: 3)
                }
                .onChange(of: scenePhase) { _, newPhase in
                    print("scenePhase: \(newPhase)")
                    if newPhase == .active {
                        openAd.tryToPresentAd()
                        openAd.appHasEnterBackgroundBefore = false
                    } else if newPhase == .background {
                        openAd.appHasEnterBackgroundBefore = true
                    }
                }
        }
    }
}
