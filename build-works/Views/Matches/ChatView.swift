import SwiftUI

struct ChatView: View {
    let match: Match
    @State private var messageText = ""
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            flightInfoBanner
            messagesList
            messageInput
        }
        .navigationTitle(match.user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var flightInfoBanner: some View {
        HStack(spacing: 16) {
            Label(match.user.flight, systemImage: "airplane")
            Label("Gate \(match.user.gate)", systemImage: "door.right.hand.open")
            Label(match.user.destination, systemImage: "mappin")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
    }
    
    private var messagesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(match.messages) { message in
                    MessageBubble(message: message, isFromCurrentUser: Bool.random())
                }
            }
            .padding()
        }
    }
    
    private var messageInput: some View {
        HStack(spacing: 12) {
            TextField("Message...", text: $messageText)
                .textFieldStyle(.plain)
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(LayoverTheme.primaryGradient)
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        appState.sendMessage(to: match, text: messageText)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }
            
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isFromCurrentUser ? LayoverTheme.primaryGradient : LinearGradient(colors: [Color(.systemGray5)], startPoint: .leading, endPoint: .trailing))
                .foregroundStyle(isFromCurrentUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            
            if !isFromCurrentUser { Spacer() }
        }
    }
}
//
//#Preview {
//    NavigationStack {
//        ChatView(match: Match.sampleMatches[0])
//    }
//}
