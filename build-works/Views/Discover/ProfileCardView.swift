import SwiftUI

struct ProfileCardView: View {
    let user: User
    let isTop: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            cardBackground
            cardContent
        }
        .clipShape(RoundedRectangle(cornerRadius: LayoverTheme.cardCornerRadius))
        .shadow(color: .black.opacity(0.15), radius: LayoverTheme.cardShadow, y: 4)
    }
    
    private var cardBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemGray4), Color(.systemGray3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Image(systemName: user.photos.first ?? "person.fill")
                .font(.system(size: 120))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(height: 480)
    }
    
    private var cardContent: some View {
        VStack(spacing: 0) {
            Spacer()
            userInfoOverlay
        }
    }
    
    private var userInfoOverlay: some View {
        VStack(alignment: .leading, spacing: 12) {
            nameAndAge
            bioText
            flightInfoRow
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(infoGradient)
    }
    
    private var nameAndAge: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(user.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("\(user.age)")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    private var bioText: some View {
        Text(user.bio)
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.9))
            .lineLimit(2)
    }
    
    private var flightInfoRow: some View {
        HStack(spacing: 16) {
            FlightInfoBadge(icon: "airplane", text: user.flight)
            FlightInfoBadge(icon: "door.right.hand.open", text: "Gate \(user.gate)")
            FlightInfoBadge(icon: "mappin.circle", text: user.destination)
        }
    }
    
    private var infoGradient: some View {
        LinearGradient(
            colors: [.clear, .black.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct FlightInfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(.white.opacity(0.85))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.white.opacity(0.2))
        .clipShape(Capsule())
    }
}

//#Preview {
//    ProfileCardView(user: User, isTop: true)
//        .padding()
//}
