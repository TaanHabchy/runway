import SwiftUI

struct AirportHeaderView: View {
    let airport: Airport
    
    var body: some View {
        HStack(spacing: 12) {
            airportIcon
            airportInfo
            Spacer()
            liveIndicator
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    private var airportIcon: some View {
        ZStack {
            Circle()
                .fill(LayoverTheme.primaryGradient)
                .frame(width: 44, height: 44)
            
            Image(systemName: "airplane.departure")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
    
    private var airportInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(airport.code)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(airport.terminal)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var liveIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
            
            Text("Live")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.systemGray5))
        .clipShape(Capsule())
    }
}

//#Preview {
//    AirportHeaderView(airport: Airport.sample)
//}
