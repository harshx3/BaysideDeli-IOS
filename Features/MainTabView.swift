//
//  MainTabView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/3/25.
//

import SwiftUI

struct MainTabView: View {
    
    // We access the global auth state to see if we should show a badge or generic profile
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView {
            // Tab 1: The Menu (What we built so far)
            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "fork.knife")
                }
            
            // Tab 2: The Profile (Login/Signup/SignOut)
            NavigationStack {
                // Logic: If logged in, show "My Account". If guest, show "Login Screen".
                if appViewModel.isAuthenticated {
                    UserProfileView() // We will create this next!
                } else {
                    AuthView()
                }
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
        // Optional: Change the color of the active tab
        .tint(.black)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppViewModel()) // Inject for preview
}
