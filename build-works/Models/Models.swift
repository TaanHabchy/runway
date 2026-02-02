import SwiftUI

struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
    let age: Int
    let bio: String
    let photos: [String]
    let destination: String
    let flight: String
    let gate: String
    let boardingTime: Date
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

struct Airport: Identifiable {
    let id: UUID
    let code: String
    let name: String
    let terminal: String
}

struct Match: Identifiable {
    let id: UUID
    let user: User
    var messages: [Message]
    let matchedAt: Date
}

struct Message: Identifiable {
    let id: UUID
    let senderId: UUID
    let text: String
    let timestamp: Date
}

// MARK: - Sample Data
extension User {
    static let sampleCurrentUser = User(
        id: UUID(),
        name: "Alex",
        age: 28,
        bio: "Adventure seeker ✈️ Coffee enthusiast ☕",
        photos: ["person.fill"],
        destination: "Paris",
        flight: "AF 123",
        gate: "B22",
        boardingTime: Date().addingTimeInterval(3600)
    )
    
    static let sampleUsers: [User] = [
        User(id: UUID(), name: "Emma", age: 26, bio: "Wanderlust & wine lover 🍷 Currently exploring the world one airport at a time", photos: ["person.fill"], destination: "Tokyo", flight: "JL 408", gate: "A15", boardingTime: Date().addingTimeInterval(5400)),
        User(id: UUID(), name: "James", age: 31, bio: "Tech entrepreneur, frequent flyer, dog dad 🐕", photos: ["person.fill"], destination: "London", flight: "BA 178", gate: "C8", boardingTime: Date().addingTimeInterval(7200)),
        User(id: UUID(), name: "Sofia", age: 24, bio: "Medical student catching flights between exams ✨", photos: ["person.fill"], destination: "Barcelona", flight: "IB 623", gate: "B22", boardingTime: Date().addingTimeInterval(4500)),
        User(id: UUID(), name: "Marcus", age: 29, bio: "Music producer on world tour 🎵", photos: ["person.fill"], destination: "Berlin", flight: "LH 456", gate: "D12", boardingTime: Date().addingTimeInterval(6000)),
        User(id: UUID(), name: "Lily", age: 27, bio: "Food blogger discovering flavors around the globe 🍜", photos: ["person.fill"], destination: "Bangkok", flight: "TG 921", gate: "A20", boardingTime: Date().addingTimeInterval(8000))
    ]
}

extension Airport {
    static let sample = Airport(
        id: UUID(),
        code: "JFK",
        name: "John F. Kennedy International",
        terminal: "Terminal 4"
    )
}

extension Match {
    static let sampleMatches: [Match] = [
        Match(id: UUID(), user: User(id: UUID(), name: "Rachel", age: 25, bio: "NYC → Anywhere", photos: ["person.fill"], destination: "Miami", flight: "AA 201", gate: "B5", boardingTime: Date().addingTimeInterval(3000)), messages: [
            Message(id: UUID(), senderId: UUID(), text: "Hey! Same terminal?", timestamp: Date().addingTimeInterval(-1800)),
            Message(id: UUID(), senderId: UUID(), text: "Yes! Gate B5, wanna grab coffee?", timestamp: Date().addingTimeInterval(-1200))
        ], matchedAt: Date().addingTimeInterval(-7200))
    ]
}
