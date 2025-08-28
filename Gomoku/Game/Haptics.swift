//
// Lightweight haptics manager
//

import Foundation
import UIKit

enum Haptics {
    private static var isEnabled: Bool {
        if UserDefaults.standard.object(forKey: "hapticsEnabled") == nil {
            // Default to enabled if not set
            return true
        }
        return UserDefaults.standard.bool(forKey: "hapticsEnabled")
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    static func selection() {
        guard isEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}


