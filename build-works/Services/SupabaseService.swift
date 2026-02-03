import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://snuxxqknfidvkgkutvyi.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNudXh4cWtuZmlkdmtna3V0dnlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5MzQ5MDgsImV4cCI6MjA3NzUxMDkwOH0.p2fwI8U2Zl2m4ChbF8JYy_WUQWqCanBLsdotXTiul4U"
        )
    }
    
    // MARK: - Auth
    
    func signUp(email: String, password: String) async throws {
        _ = try await client.auth.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        _ = try await client.auth.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUserId() async throws -> String {
        let id = try await client.auth.session.user.id
        return id.uuidString
    }
    
    // MARK: - Profile Management
    
    func createProfile(_ profile: UserProfileInsert) async throws {
        try await client
            .from("profiles")
            .upsert(profile, onConflict: "user_id", ignoreDuplicates: true)
            .execute()
    }
    
    func fetchCurrentUserProfile() async throws -> UserProfile? {
        guard let userId = try? await client.auth.session.user.id else {
            return nil
        }
        
        let response: UserProfile = try await client
            .from("profiles")
            .select()
            .eq("user_id", value: userId.uuidString)
            .single()
            .execute()
            .value
        
        return response
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        try await client
            .from("profiles")
            .update(profile)
            .eq("user_id", value: profile.userId)
            .execute()
    }
    
    // MARK: - Discovery
    
    func fetchPotentialMatches(airportCode: String, terminal: String?) async throws -> [UserProfile] {
        var query = client
            .from("profiles")
            .select()
            .eq("airport_code", value: airportCode)

        if let terminal = terminal {
            query = query.eq("terminal", value: terminal)
        }

        let response: [UserProfile] = try await query
            .execute()
            .value

        // ✅ Fetch async value BEFORE using filter
        let currentUserId = try await client.auth.session.user.id.uuidString

        return response.filter { profile in
            profile.userId != currentUserId
        }
    }

    
    // MARK: - Likes & Matches
    
    func likeUser(userId: String) async throws {
        guard let currentUserId = try? await client.auth.session.user.id else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        let like = LikeRecord(fromUserId: currentUserId.uuidString, toUserId: userId)
        try await client
            .from("likes")
            .insert(like)
            .execute()
    }
    
    func fetchMatches() async throws -> [MatchData] {
        guard let userId = try? await client.auth.session.user.id else {
            return []
        }
        
        let response: [MatchData] = try await client
            .from("matches")
            .select("*, user1:profiles!matches_user1_id_fkey(*), user2:profiles!matches_user2_id_fkey(*)")
            .or("user1_id.eq.\(userId.uuidString),user2_id.eq.\(userId.uuidString)")
            .execute()
            .value
        
        return response
    }
    
    // MARK: - Messages
    
    func fetchMessages(matchId: String) async throws -> [MessageData] {
        let response: [MessageData] = try await client
            .from("messages")
            .select()
            .eq("match_id", value: matchId)
            .order("created_at", ascending: true)
            .execute()
            .value
        
        return response
    }
    
    func sendMessage(matchId: String, content: String) async throws {
        guard let userId = try? await client.auth.session.user.id else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        let message = MessageData(matchId: matchId, senderId: userId.uuidString, content: content)
        try await client
            .from("messages")
            .insert(message)
            .execute()
    }
}

// MARK: - Data Models

struct UserProfile: Codable, Identifiable {
    let id: String
    let userId: String
    let name: String
    let age: Int
    let gender: String
    let bio: String?
    let airportCode: String?
    let terminal: String?
    let flightNumber: String?
    let gate: String?
    let destination: String?
    let boardingTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, age, bio, gender
        case userId = "user_id"
        case airportCode = "airport_code"
        case terminal
        case flightNumber = "flight_number"
        case gate
        case destination
        case boardingTime = "boarding_time"
    }
}

/// Used for creating a new profile during onboarding (insert).
struct UserProfileInsert: Encodable {
    let userId: String
    let name: String
    let age: Int
    let gender: String
    let bio: String?
    let airportCode: String?
    let terminal: String?
    let flightNumber: String?
    let gate: String?
    let destination: String?
    let boardingTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case name, age, bio, gender
        case userId = "user_id"
        case airportCode = "airport_code"
        case terminal
        case flightNumber = "flight_number"
        case gate
        case destination
        case boardingTime = "boarding_time"
    }
}

struct LikeRecord: Codable {
    let fromUserId: String
    let toUserId: String
    
    enum CodingKeys: String, CodingKey {
        case fromUserId = "from_user_id"
        case toUserId = "to_user_id"
    }
}

struct MatchData: Codable, Identifiable {
    let id: String
    let user1Id: String
    let user2Id: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case user1Id = "user1_id"
        case user2Id = "user2_id"
        case createdAt = "created_at"
    }
}

struct MessageData: Codable, Identifiable {
    let id: String?
    let matchId: String
    let senderId: String
    let content: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchId = "match_id"
        case senderId = "sender_id"
        case content
        case createdAt = "created_at"
    }
    
    init(id: String? = nil, matchId: String, senderId: String, content: String, createdAt: Date? = nil) {
        self.id = id
        self.matchId = matchId
        self.senderId = senderId
        self.content = content
        self.createdAt = createdAt
    }
}
