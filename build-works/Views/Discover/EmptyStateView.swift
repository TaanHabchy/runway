import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            illustrationIcon
            
            VStack(spacing: 8) {
                titleText
                subtitleText
            }
            
            refreshButton
            
            Spacer()
        }
        .padding(32)
    }
    
    private var illustrationIcon: some View {
        ZStack {
            Circle()
                .fill(LayoverTheme.primaryGradient.opacity(0.15))
                .frame(width: 140, height: 140)
            
            Circle()
                .fill(LayoverTheme.primaryGradient.opacity(0.25))
                .frame(width: 100, height: 100)
            
            Image(systemName: "airplane.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(LayoverTheme.primaryGradient)
        }
    }
    
    private var titleText: some View {
        Text("No More Travelers")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
    }
    
    private var subtitleText: some View {
        Text("You've seen everyone at this terminal.\nCheck back soon for new arrivals!")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
    
    private var refreshButton: some View {
        Button(action: {}) {
            Label("Refresh", systemImage: "arrow.clockwise")
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    EmptyStateView()
}
