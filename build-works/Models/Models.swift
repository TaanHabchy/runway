import SwiftUI

struct User: Identifiable, Equatable {
    let id: String
    let name: String
    let age: Int
    let bio: String
    let gender: String
    let photos: [String]
    let destination: String
    let flight: String
    let gate: String
    let boardingTime: Date
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: String = UUID().uuidString, name: String, age: Int, bio: String, photos: [String], destination: String, flight: String, gate: String, boardingTime: Date, gender: String) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.gender = gender
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
        self.gender = profile.gender
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
