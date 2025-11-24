//
//  SignupView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/23/25.
//

import SwiftUI

struct SignupView: View {
    
    @State private var fullName: String
    @State private var email: String
    @State private var password: String
    @State private var confirmPassword: String
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var error: String? = nil
    @State private var success: Bool = false
    @State private var showAlert: Bool = false
    
    init(fullName: String = "", email: String = "", password: String = "", confirmPassword: String = "") {
        _fullName = State(initialValue: fullName)
        _email = State(initialValue: email)
        _password = State(initialValue: password)
        _confirmPassword = State(initialValue: confirmPassword)
    }
    
    var body: some View {
        VStack {
            Text("Create Your Account")
                .font(.largeTitle)
                
            Text("Let's get you set up to order the best sandwiches in town")
            
            TextField("Enter your full name", text: $fullName)
            TextField("Enter your email", text: $email)
            TextField("Enter your password", text: $password)
            TextField("Confirm your password", text: $confirmPassword)
            
            Button("Sign Up") {
                
            }
        }
    }
}

#Preview {
    SignupView()
}
