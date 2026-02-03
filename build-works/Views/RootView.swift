import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !appState.hasCheckedAuth {
                loadingView
            } else if !appState.isAuthenticated {
                AuthView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                ContentView()
            }
        }
    }
    
    private var loadingView: some View {
        ZStack {
            LayoverTheme.primaryGradient
                .ignoresSafeArea()
            ProgressView()
                .tint(.white)
                .scaleEffect(1.2)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
