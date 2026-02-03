import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var currentStep = 0
    @State private var name = ""
    @State private var age = ""
    @State private var selectedGender = "Prefer not to say"
    @State private var bio = ""
    @State private var airportCode = ""
    @State private var terminal = ""
    @State private var flightNumber = ""
    @State private var gate = ""
    @State private var destination = ""
    @State private var boardingTime = Date()
    
    private let genders = ["Male", "Female"]
    private let totalSteps = 4
    
    var body: some View {
        ZStack {
            LayoverTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                stepIndicator
                    .padding(.top, 20)
                
                TabView(selection: $currentStep) {
                    welcomeStep.tag(0)
                    basicsStep.tag(1)
                    bioStep.tag(2)
                    flightStep.tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: currentStep)
                
                bottomButtons
            }
        }
    }
    
    private var stepIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? Color.white : Color.white.opacity(0.4))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 32)
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(.white)
            Text("Set up your profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text("A few details help others find you at the airport and start a conversation.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
    
    private var basicsStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("About you")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gender")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { g in
                            Text(g).tag(g)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(28)
        }
    }
    
    private var bioStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Short bio")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text("Tell others a bit about yourself.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                
                TextEditor(text: $bio)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .frame(minHeight: 120)
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
            }
            .padding(28)
        }
    }
    
    private var flightStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Flight details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text("Optional — you can update this later.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                
                onboardingField("Airport code", text: $airportCode, placeholder: "e.g. JFK")
                onboardingField("Terminal", text: $terminal, placeholder: "e.g. 4")
                onboardingField("Flight number", text: $flightNumber, placeholder: "e.g. AA 123")
                onboardingField("Gate", text: $gate, placeholder: "e.g. B12")
                onboardingField("Destination", text: $destination, placeholder: "e.g. London")
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Boarding time")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    DatePicker("", selection: $boardingTime, displayedComponents: .date)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(28)
        }
    }
    
    private func onboardingField(_ label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
            TextField(placeholder, text: text)
                .padding()
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
        }
    }
    
    private var bottomButtons: some View {
        VStack(spacing: 16) {
            if let error = appState.authError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            Button {
                if currentStep < totalSteps - 1 {
                    withAnimation { currentStep += 1 }
                } else {
                    submitOnboarding()
                }
            } label: {
                HStack {
                    if appState.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(currentStep < totalSteps - 1 ? "Continue" : "Finish")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(appState.isLoading || !canProceed)
            
            if currentStep > 0 {
                Button("Back") {
                    withAnimation { currentStep -= 1 }
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 40)
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0: return true
        case 1: return !name.trimmingCharacters(in: .whitespaces).isEmpty && Int(age) != nil && (Int(age).map { $0 >= 18 && $0 <= 120 } ?? false)
        case 2, 3: return true
        default: return false
        }
    }
    
    private func submitOnboarding() {
        Task {
            do {
                let userId = try await SupabaseService.shared.getCurrentUserId()
                let ageInt = Int(age) ?? 18
                let profile = UserProfileInsert(
                    userId: userId,
                    name: name.trimmingCharacters(in: .whitespaces),
                    age: ageInt,
                    gender: selectedGender,
                    bio: bio.isEmpty ? nil : bio,
                    airportCode: airportCode.isEmpty ? nil : airportCode,
                    terminal: terminal.isEmpty ? nil : terminal,
                    flightNumber: flightNumber.isEmpty ? nil : flightNumber,
                    gate: gate.isEmpty ? nil : gate,
                    destination: destination.isEmpty ? nil : destination,
                    boardingTime: boardingTime
                )
                await appState.completeOnboarding(profile: profile)
            } catch {
                await MainActor.run { appState.authError = error.localizedDescription }
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
