import SwiftUI

class AppState: ObservableObject {
    @Published var currentUser: User = User.sampleCurrentUser
    @Published var matches: [Match] = Match.sampleMatches
    @Published var potentialMatches: [User] = User.sampleUsers
    @Published var currentAirport: Airport = Airport.sample
    
    func likeUser(_ user: User) {
        if let index = potentialMatches.firstIndex(where: { $0.id == user.id }) {
            potentialMatches.remove(at: index)
            // Simulate a match (50% chance)
            if Bool.random() {
                let newMatch = Match(id: UUID(), user: user, messages: [], matchedAt: Date())
                matches.append(newMatch)
            }
        }
    }
    
    func dislikeUser(_ user: User) {
        potentialMatches.removeAll { $0.id == user.id }
    }
}
