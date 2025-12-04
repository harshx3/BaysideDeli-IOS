//
//  UserProfileView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/3/25.
//


import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray)
            
            Text(appViewModel.currentUserEmail ?? "User")
                .font(.title2)
                .bold()
            
            // This is where we will eventually put "Past Orders" button
            
            Button(role: .destructive) {
                Task {
                    await appViewModel.signOut()
                }
            } label: {
                Text("Sign Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundStyle(.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("My Account")
    }
}

#Preview {
    UserProfileView()
}
