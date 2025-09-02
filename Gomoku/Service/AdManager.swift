//
//  AdManager.swift
//  TimesMatter
//
//  Created by Lulin Yang on 2025/7/11.
//

import AdSupport
import AppTrackingTransparency

class AdManager {
    static var isAuthorized = false

    static func requestATTPermission(with time: TimeInterval = 0) {
        guard !isAuthorized else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    isAuthorized = true
    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}
