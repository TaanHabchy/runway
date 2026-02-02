import SwiftUI

enum LayoverTheme {
    // Primary colors - warm sunset tones for romance & travel
    static let primaryGradient = LinearGradient(
        colors: [Color("AccentPink"), Color("AccentOrange")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentPink = Color("AccentPink")
    static let accentOrange = Color("AccentOrange")
    static let accentPurple = Color("AccentPurple")
    
    // Semantic colors
    static let like = Color.green
    static let dislike = Color.red.opacity(0.8)
    
    // Card styling
    static let cardCornerRadius: CGFloat = 20
    static let cardShadow: CGFloat = 8
    
    // Animation
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.7)
}

// Custom button style for primary actions
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(LayoverTheme.primaryGradient)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
