import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var showMatchAlert = false
    @State private var matchedUser: User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 0) {
                    airportHeader
                    
                    if appState.potentialMatches.isEmpty {
                        EmptyStateView()
                    } else {
                        cardStack
                        actionButtons
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("It's a Match! ✈️", isPresented: $showMatchAlert) {
                Button("Send Message") { }
                Button("Keep Swiping", role: .cancel) { }
            } message: {
                if let user = matchedUser {
                    Text("You and \(user.name) both liked each other!")
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color(.systemBackground), Color(.systemGray6)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var airportHeader: some View {
        AirportHeaderView(airport: appState.currentAirport)
    }
    
    private var cardStack: some View {
        CardStackView(
            users: appState.potentialMatches,
            dragOffset: $dragOffset,
            onLike: handleLike,
            onDislike: handleDislike
        )
    }
    
    private var actionButtons: some View {
        ActionButtonsView(
            onDislike: { handleDislike(appState.potentialMatches.first) },
            onLike: { handleLike(appState.potentialMatches.first) },
            isDisabled: appState.potentialMatches.isEmpty
        )
    }
    
    private func handleLike(_ user: User?) {
        guard let user = user else { return }
        let wasMatch = appState.matches.count
        appState.likeUser(user)
        if appState.matches.count > wasMatch {
            matchedUser = user
            showMatchAlert = true
        }
    }
    
    private func handleDislike(_ user: User?) {
        guard let user = user else { return }
        appState.dislikeUser(user)
    }
}

#Preview {
    DiscoverView()
        .environmentObject(AppState())
}
