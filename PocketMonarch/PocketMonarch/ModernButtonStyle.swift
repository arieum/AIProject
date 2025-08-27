import SwiftUI

struct ModernButtonStyle: ButtonStyle {
    var tint: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(tint))
            .shadow(color: tint.opacity(configuration.isPressed ? 0.2 : 0.3),
                    radius: configuration.isPressed ? 2 : 6,
                    y: configuration.isPressed ? 1 : 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
