import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appState: AppState
    @State private var dragOffset: CGSize = .zero
    @State private var showMatchAlert = false
    @State private var matchedUser: User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 0) {
                    if let currentUser = appState.currentUser {
//                        airportHeader
                        
                        if appState.potentialMatches.isEmpty {
                            EmptyStateView()
                                .padding(.top, 50)
                        } else {
                            cardStack
                            actionButtons
                        }
                    } else if appState.isLoading {
                        ProgressView()
                            .padding(.top, 50)
                    } else {
                        Text("No profile loaded")
                            .foregroundStyle(.secondary)
                            .padding(.top, 50)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("It's a Match! ✈️", isPresented: $showMatchAlert) {
                Button("Send Message") { /* TODO: Navigate to chat */ }
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
    
//    private var airportHeader: some View {
//        AirportHeaderView(airport: appState.currentAirport)
//    }
//    
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
    
    // MARK: - Actions
    
    private func handleLike(_ user: User?) {
        guard let user = user else { return }
        
        Task {
            // Track number of matches before liking
            let previousMatchesCount = appState.matches.count
            await appState.likeUser(user)
            
            // If a new match appeared, show alert
            if appState.matches.count > previousMatchesCount {
                matchedUser = user
                showMatchAlert = true
            }
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
