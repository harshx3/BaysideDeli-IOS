//
//  AuthView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/3/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var appViewModel: AppViewModel // access the gloabal state
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false // toggle b/w Login/Signup
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let service = AuthService()
    var body: some View {
            VStack(spacing: 20) {
                
                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never) // Important for emails!
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button(action: performAuth) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text(isSignUp ? "Sign Up" : "Log In")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                
                Button {
                    isSignUp.toggle()
                } label: {
                    Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                }
                
                Spacer()
            }
            .padding()
        }
        
        private func performAuth() {
            isLoading = true
            errorMessage = nil
            
            Task {
                do {
                    if isSignUp {
                        try await service.signUp(email: email, password: password)
                    } else {
                        try await service.signIn(email: email, password: password)
                    }
                    // Update the global state
                    appViewModel.checkSession()
                    
                } catch {
                    errorMessage = error.localizedDescription
                }
                isLoading = false
            }
        }
}


#Preview {
    AuthView()
}
