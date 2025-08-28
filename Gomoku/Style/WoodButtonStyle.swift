//
// Created by Banghua Zhao on 28/08/2025
// Copyright Apps Bay Limited. All rights reserved.
//

import SwiftUI

struct WoodButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 12

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(
                Image("board")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: .black.opacity(configuration.isPressed ? 0.15 : 0.3),
                radius: configuration.isPressed ? 1 : 3, x: 0, y: configuration.isPressed ? 0 : 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

extension ButtonStyle where Self == WoodButtonStyle {
    static var woodStyle: WoodButtonStyle { WoodButtonStyle() }
}

#Preview {
    Button("Wooden Button") {
        print("Button tapped")
    }
    .buttonStyle(.woodStyle)
}
