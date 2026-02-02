import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    flightCard
                    settingsPlaceholder
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            avatarView
            
            VStack(spacing: 4) {
                Text("\(appState.currentUser.name), \(appState.currentUser.age)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(appState.currentUser.bio)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Edit Profile") {}
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding(.vertical, 24)
    }
    
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(LayoverTheme.primaryGradient)
                .frame(width: 120, height: 120)
            
            Image(systemName: "person.fill")
                .font(.system(size: 50))
                .foregroundStyle(.white)
        }
    }
    
    private var flightCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Flight")
                .font(.headline)
            
            HStack {
                FlightDetailItem(icon: "airplane.departure", title: "Flight", value: appState.currentUser.flight)
                Spacer()
                FlightDetailItem(icon: "door.right.hand.open", title: "Gate", value: appState.currentUser.gate)
                Spacer()
                FlightDetailItem(icon: "mappin.circle", title: "To", value: appState.currentUser.destination)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var settingsPlaceholder: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "bell.fill", title: "Notifications", color: .red)
            SettingsRow(icon: "lock.fill", title: "Privacy", color: .blue)
            SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .green)
            SettingsRow(icon: "info.circle.fill", title: "About", color: .purple)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct FlightDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(LayoverTheme.accentPink)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)
                .frame(width: 28)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
