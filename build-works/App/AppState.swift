import SwiftUI
import Supabase

@MainActor
class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var matches: [Match] = []
    @Published var potentialMatches: [User] = []
    @Published var isLoading = false
    @Published var isAuthenticated = false
    
    private let supabase = SupabaseService.shared
    
    init() {
        Task {
            await checkAuth()
        }
    }
    
    func checkAuth() async {
        do {
            let session = try await supabase.client.auth.session
            guard let userId = session.user.id.uuidString as String? else {
                isAuthenticated = false
                return
            }
            isAuthenticated = true
            
            // Load current user profile
            if let profile = try? await supabase.fetchCurrentUserProfile() {
                currentUser = User(from: profile)
            }
            
            await loadUserData()
        } catch {
            isAuthenticated = false
            print("Not authenticated or failed to fetch session: \(error)")
        }
    }
    
    func loadUserData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            await loadPotentialMatches()
            await loadMatches()
        } catch {
            print("Error loading user data: \(error)")
        }
    }
    
    func loadPotentialMatches() async {
        do {
            // Fetch all users except the current user
            let profiles = try await supabase.client
                .from("profiles")
                .select()
                .execute()
                .value as [UserProfile]
            
            if let currentUserId = currentUser?.id {
                potentialMatches = profiles
                    .filter { $0.userId != currentUserId }
                    .map { User(from: $0) }
            } else {
                potentialMatches = profiles.map { User(from: $0) }
            }
        } catch {
            print("Error fetching potential matches: \(error)")
        }
    }
    
    func loadMatches() async {
        do {
            let matchesData = try await supabase.fetchMatches()
            var loadedMatches: [Match] = []
            
            guard let currentUserId = currentUser?.id else { return }
            
            for matchData in matchesData {
                let messagesData = try await supabase.fetchMessages(matchId: matchData.id)
                
                let otherUserId = matchData.user1Id == currentUserId ? matchData.user2Id : matchData.user1Id
                
                // Fetch full profile for the other user
                if let otherProfile = try? await supabase.client
                    .from("profiles")
                    .select()
                    .eq("user_id", value: otherUserId)
                    .single()
                    .execute()
                    .value as UserProfile? {
                    
                    let user = User(from: otherProfile)
                    
                    let match = Match(
                        id: matchData.id,
                        user: user,
                        messages: messagesData.map { Message(from: $0) },
                        matchedAt: matchData.createdAt
                    )
                    
                    loadedMatches.append(match)
                }
            }
            
            matches = loadedMatches
        } catch {
            print("Error fetching matches: \(error)")
        }
    }
    
    func likeUser(_ user: User) {
        Task {
            do {
                try await supabase.likeUser(userId: user.id)
                potentialMatches.removeAll { $0.id == user.id }
                await loadMatches() // reload matches for mutual likes
            } catch {
                print("Error liking user: \(error)")
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
