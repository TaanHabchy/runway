import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let user = appState.currentUser {
                        profileHeader(for: user)
                        flightCard(for: user)
                        settingsPlaceholder
                    } else if appState.isLoading {
                        ProgressView()
                            .padding(.top, 50)
                    } else {
                        Text("No profile data available")
                            .foregroundStyle(.secondary)
                            .padding(.top, 50)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
        }
    }
    
    // MARK: - Subviews
    
    private func profileHeader(for user: User) -> some View {
        VStack(spacing: 16) {
            avatarView
            
            VStack(spacing: 4) {
                Text("\(user.name), \(user.age)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if !user.bio.isEmpty {
                    Text(user.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("No bio provided")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }

            
            Button("Edit Profile") {
                // TODO: Add edit action
            }
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
    
    private func flightCard(for user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Flight")
                .font(.headline)
            
            HStack {
                FlightDetailItem(icon: "airplane.departure", title: "Flight", value: user.flight)
                Spacer()
                FlightDetailItem(icon: "door.right.hand.open", title: "Gate", value: user.gate)
                Spacer()
                FlightDetailItem(icon: "mappin.circle", title: "To", value: user.destination)
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
            
            Button {
                Task { await appState.signOut() }
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.body)
                        .foregroundStyle(.red)
                        .frame(width: 28)
                    Text("Sign Out")
                        .font(.body)
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Subcomponents

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
            
            Text(value.isEmpty ? "-" : value)
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

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
