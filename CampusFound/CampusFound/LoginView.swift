//
//  LoginView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("CampusFound")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Sign in with your university email to report or find lost items on campus.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                TextField("name@suu.edu", text: $session.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                if let error = session.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: {
                    session.login()
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .navigationTitle("Log In")
        }
    }
}
