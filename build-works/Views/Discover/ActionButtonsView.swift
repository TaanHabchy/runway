import SwiftUI

struct ActionButtonsView: View {
    let onDislike: () -> Void
    let onLike: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        HStack(spacing: 40) {
            dislikeButton
            likeButton
        }
        .padding(.vertical, 24)
    }
    
    private var dislikeButton: some View {
        Button(action: onDislike) {
            ZStack {
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 64, height: 64)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
                
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(LayoverTheme.dislike)
            }
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
    
    private var likeButton: some View {
        Button(action: onLike) {
            ZStack {
                Circle()
                    .fill(LayoverTheme.primaryGradient)
                    .frame(width: 72, height: 72)
                    .shadow(color: LayoverTheme.accentPink.opacity(0.4), radius: 12, y: 4)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    ActionButtonsView(onDislike: {}, onLike: {}, isDisabled: false)
}
