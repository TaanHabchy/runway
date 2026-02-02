import SwiftUI

struct MatchesView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            Group {
                if appState.matches.isEmpty {
                    emptyMatchesView
                } else {
                    matchesList
                }
            }
            .navigationTitle("Matches")
        }
    }
    
    private var emptyMatchesView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Matches Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Keep swiping to find your travel companion!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var matchesList: some View {
        List(appState.matches) { match in
            NavigationLink(destination: ChatView(match: match).environmentObject(appState)) {
                MatchRowView(match: match)
            }
        }
        .listStyle(.plain)
    }
}

struct MatchRowView: View {
    let match: Match
    
    var body: some View {
        HStack(spacing: 14) {
            avatarView
            matchInfo
            Spacer()
            flightBadge
        }
        .padding(.vertical, 8)
    }
    
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(LayoverTheme.primaryGradient)
                .frame(width: 56, height: 56)
            
            Image(systemName: "person.fill")
                .font(.title2)
                .foregroundStyle(.white)
        }
    }
    
    private var matchInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(match.user.name)
                .font(.headline)
            
            if let lastMessage = match.messages.last {
                Text(lastMessage.text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            } else {
                Text("Say hello! 👋")
                    .font(.subheadline)
                    .foregroundStyle(LayoverTheme.accentPink)
            }
        }
    }
    
    private var flightBadge: some View {
        Text(match.user.destination)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray5))
            .clipShape(Capsule())
    }
}

#Preview {
    MatchesView()
        .environmentObject(AppState())
}
