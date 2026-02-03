import SwiftUI

struct AuthView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            LayoverTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                headerView
                
                VStack(spacing: 20) {
                    emailField
                    passwordField
                    if isSignUp { confirmPasswordField }
                    
                    if let error = appState.authError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    primaryButton
                }
                .padding(.horizontal, 28)
                
                toggleModeButton
                
                Spacer()
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "airplane.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.white)
            Text("Layover")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text(isSignUp ? "Create an account" : "Welcome back")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
    
    private var emailField: some View {
        TextField("Email", text: $email)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .padding()
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var passwordField: some View {
        SecureField("Password", text: $password)
            .textContentType(isSignUp ? .newPassword : .password)
            .padding()
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var confirmPasswordField: some View {
        SecureField("Confirm password", text: $confirmPassword)
            .textContentType(.newPassword)
            .padding()
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var primaryButton: some View {
        Button {
            Task {
                if isSignUp {
                    guard password == confirmPassword else {
                        appState.authError = "Passwords don't match"
                        return
                    }
                    await appState.signUp(email: email, password: password)
                } else {
                    await appState.signIn(email: email, password: password)
                }
            }
        } label: {
            HStack {
                if appState.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(isSignUp ? "Sign Up" : "Log In")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(appState.isLoading || email.isEmpty || password.isEmpty || (isSignUp && confirmPassword != password))
    }
    
    private var toggleModeButton: some View {
        Button {
            isSignUp.toggle()
            appState.authError = nil
        } label: {
            Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.95))
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    AuthView()
        .environmentObject(AppState())
}
