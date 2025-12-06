//
//  AppViewModel.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/3/25.
//

import Foundation
import Combine
import Supabase

@MainActor
class AppViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUserEmail: String?
    
    private let authService = AuthService()
    
    init() {
        checkSession()
    }
    
    func checkSession() {
        if let user = authService.currentUser {
            self.isAuthenticated = true
            self.currentUserEmail = user.email
            print("User is logged in: \(user.email ?? "")")
        } else {
            self.isAuthenticated = false
            print("No user logged in")
        }
    }
    
    func signOut() async {
        do {
            try await authService.signOut()
            self.isAuthenticated = false
            self.currentUserEmail = nil
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    // Add this inside the AppViewModel class
    var currentUser: User? {
        return authService.currentUser
    }
}
