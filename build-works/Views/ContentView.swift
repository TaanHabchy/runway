import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .discover
    
    enum Tab {
        case discover, matches, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "airplane")
                }
                .tag(Tab.discover)
            
            MatchesView()
                .tabItem {
                    Label("Matches", systemImage: "heart.fill")
                }
                .tag(Tab.matches)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(LayoverTheme.accentPink)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
