//
//  SessionViewModel.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import Foundation
import Combine

class SessionViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var email: String = ""
    @Published var errorMessage: String?

    func login() {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard trimmed.hasSuffix(".edu") else {
            errorMessage = "Please use a valid university .edu email."
            isLoggedIn = false
            return
        }

        errorMessage = nil
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        email = ""
        errorMessage = nil
    }
}

