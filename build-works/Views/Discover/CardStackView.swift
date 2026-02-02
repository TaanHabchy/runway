import SwiftUI

struct CardStackView: View {
    let users: [User]
    @Binding var dragOffset: CGSize
    let onLike: (User?) -> Void
    let onDislike: (User?) -> Void
    
    var body: some View {
        ZStack {
            ForEach(Array(users.prefix(3).enumerated().reversed()), id: \.element.id) { index, user in
                let isTop = index == 0
                ProfileCardView(user: user, isTop: isTop)
                    .offset(x: isTop ? dragOffset.width : 0, y: CGFloat(index) * 8)
                    .scaleEffect(isTop ? 1 : 1 - CGFloat(index) * 0.05)
                    .rotationEffect(.degrees(isTop ? Double(dragOffset.width / 20) : 0))
                    .gesture(isTop ? dragGesture : nil)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: dragOffset)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                handleSwipeEnd(value.translation.width)
            }
    }
    
    private func handleSwipeEnd(_ width: CGFloat) {
        let threshold: CGFloat = 100
        if width > threshold {
            withAnimation(.easeOut(duration: 0.3)) {
                dragOffset.width = 500
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onLike(users.first)
                dragOffset = .zero
            }
        } else if width < -threshold {
            withAnimation(.easeOut(duration: 0.3)) {
                dragOffset.width = -500
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onDislike(users.first)
                dragOffset = .zero
            }
        } else {
            withAnimation { dragOffset = .zero }
        }
    }
}
