//
//  ProfileView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)

                Text(session.email)
                    .font(.headline)

                Text("Student / Staff at SUU")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(role: .destructive) {
                    session.logout()
                } label: {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
