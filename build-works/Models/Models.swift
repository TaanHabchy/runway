import SwiftUI

struct User: Identifiable, Equatable {
    let id: String
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
    
    init(id: String = UUID().uuidString, name: String, age: Int, bio: String, photos: [String], destination: String, flight: String, gate: String, boardingTime: Date) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.photos = photos
        self.destination = destination
        self.flight = flight
        self.gate = gate
        self.boardingTime = boardingTime
    }
    
    init(from profile: UserProfile) {
        self.id = profile.id
        self.name = profile.name
        self.age = profile.age
        self.bio = profile.bio ?? ""
        self.photos = ["person.fill"]
        self.destination = profile.destination ?? "Unknown"
        self.flight = profile.flightNumber ?? ""
        self.gate = profile.gate ?? ""
        self.boardingTime = profile.boardingTime ?? Date()
    }
}

struct Airport: Identifiable {
    let id: String
    let code: String
    let name: String
    let terminal: String
    
    init(id: String = UUID().uuidString, code: String, name: String, terminal: String) {
        self.id = id
        self.code = code
        self.name = name
        self.terminal = terminal
    }
}

struct Match: Identifiable {
    let id: String
    let user: User
    var messages: [Message]
    let matchedAt: Date
    
    init(id: String = UUID().uuidString, user: User, messages: [Message] = [], matchedAt: Date = Date()) {
        self.id = id
        self.user = user
        self.messages = messages
        self.matchedAt = matchedAt
    }
}

struct Message: Identifiable {
    let id: String
    let senderId: String
    let text: String
    let timestamp: Date
    
    init(id: String = UUID().uuidString, senderId: String, text: String, timestamp: Date = Date()) {
        self.id = id
        self.senderId = senderId
        self.text = text
        self.timestamp = timestamp
    }
    
    init(from messageData: MessageData) {
        self.id = messageData.id ?? UUID().uuidString
        self.senderId = messageData.senderId
        self.text = messageData.content
        self.timestamp = messageData.createdAt ?? Date()
    }
}

// MARK: - Sample Data
extension User {
    static let sampleCurrentUser = User(
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
        User(name: "Emma", age: 26, bio: "Wanderlust & wine lover 🍷 Currently exploring the world one airport at a time", photos: ["person.fill"], destination: "Tokyo", flight: "JL 408", gate: "A15", boardingTime: Date().addingTimeInterval(5400)),
        User(name: "James", age: 31, bio: "Tech entrepreneur, frequent flyer, dog dad 🐕", photos: ["person.fill"], destination: "London", flight: "BA 178", gate: "C8", boardingTime: Date().addingTimeInterval(7200)),
        User(name: "Sofia", age: 24, bio: "Medical student catching flights between exams ✨", photos: ["person.fill"], destination: "Barcelona", flight: "IB 623", gate: "B22", boardingTime: Date().addingTimeInterval(4500)),
        User(name: "Marcus", age: 29, bio: "Music producer on world tour 🎵", photos: ["person.fill"], destination: "Berlin", flight: "LH 456", gate: "D12", boardingTime: Date().addingTimeInterval(6000)),
        User(name: "Lily", age: 27, bio: "Food blogger discovering flavors around the globe 🍜", photos: ["person.fill"], destination: "Bangkok", flight: "TG 921", gate: "A20", boardingTime: Date().addingTimeInterval(8000))
    ]
}

extension Airport {
    static let sample = Airport(
        code: "JFK",
        name: "John F. Kennedy International",
        terminal: "Terminal 4"
    )
}

extension Match {
    static let sampleMatches: [Match] = [
        Match(user: User(name: "Rachel", age: 25, bio: "NYC → Anywhere", photos: ["person.fill"], destination: "Miami", flight: "AA 201", gate: "B5", boardingTime: Date().addingTimeInterval(3000)), messages: [
            Message(senderId: UUID().uuidString, text: "Hey! Same terminal?", timestamp: Date().addingTimeInterval(-1800)),
            Message(senderId: UUID().uuidString, text: "Yes! Gate B5, wanna grab coffee?", timestamp: Date().addingTimeInterval(-1200))
        ], matchedAt: Date().addingTimeInterval(-7200))
    ]
}
