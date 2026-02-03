import SwiftUI
import Supabase

class AppState: ObservableObject {
    @Published var currentUser: User = User.sampleCurrentUser
    @Published var matches: [Match] = []
    @Published var potentialMatches: [User] = []
    @Published var currentAirport: Airport = Airport.sample
    @Published var isLoading = false
    @Published var isAuthenticated = false
    
    private let supabase = SupabaseService.shared
    private var messageChannels: [String: RealtimeChannel] = [:]
    
    init() {
        Task {
            await checkAuth()
        }
    }
    
    @MainActor
    func checkAuth() async {
        do {
            let session = try await supabase.client.auth.session
            isAuthenticated = true
            await loadUserData()
        } catch {
            isAuthenticated = false
            // Use sample data for demo
            potentialMatches = User.sampleUsers
            matches = Match.sampleMatches
        }
    }
    
    @MainActor
    func loadUserData() async {
        isLoading = true
        do {
            await loadPotentialMatches()
            await loadMatches()
        } catch {
            print("Error loading data: \(error)")
        }
        isLoading = false
    }
    
    @MainActor
    func loadPotentialMatches() async {
        do {
            let profiles = try await supabase.fetchPotentialMatches(
                airportCode: currentAirport.code,
                terminal: currentAirport.terminal
            )
            potentialMatches = profiles.map { User(from: $0) }
        } catch {
            print("Error fetching potential matches: \(error)")
            potentialMatches = User.sampleUsers
        }
    }
    
    @MainActor
    func loadMatches() async {
        do {
            let matchesData = try await supabase.fetchMatches()
            var loadedMatches: [Match] = []
            
            for matchData in matchesData {
                let messages = try await supabase.fetchMessages(matchId: matchData.id)
                // Determine the other user in the match
                guard let session = try? await supabase.client.auth.session else { continue }
                let otherUserId = matchData.user1Id == session.user.id.uuidString ? matchData.user2Id : matchData.user1Id
                
                // For now, create placeholder user (would fetch full profile in production)
                let user = User(
                    id: otherUserId,
                    name: "User",
                    age: 25,
                    bio: "Matched!",
                    photos: ["person.fill"],
                    destination: "Unknown",
                    flight: "",
                    gate: "",
                    boardingTime: Date()
                )
                
                let match = Match(
                    id: matchData.id,
                    user: user,
                    messages: messages.map { Message(from: $0) },
                    matchedAt: matchData.createdAt
                )
                loadedMatches.append(match)

            }
            
            matches = loadedMatches
        } catch {
            print("Error fetching matches: \(error)")
            matches = Match.sampleMatches
        }
    }
    
    func likeUser(_ user: User) {
        Task {
            do {
                try await supabase.likeUser(userId: user.id)
                await MainActor.run {
                    potentialMatches.removeAll { $0.id == user.id }
                }
                // Reload matches to see if mutual like occurred
                await loadMatches()
            } catch {
                print("Error liking user: \(error)")
                // Fallback to local simulation
                await MainActor.run {
                    if let index = potentialMatches.firstIndex(where: { $0.id == user.id }) {
                        potentialMatches.remove(at: index)
                        if Bool.random() {
                            let newMatch = Match(user: user)
                            matches.append(newMatch)
                        }
                    }
                }
            }
        }
    }
    
    func dislikeUser(_ user: User) {
        potentialMatches.removeAll { $0.id == user.id }
    }
    
    func sendMessage(to match: Match, text: String) {
        Task {
            do {
                try await supabase.sendMessage(matchId: match.id, content: text)
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }
}
