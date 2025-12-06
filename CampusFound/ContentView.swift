//
//  ContentView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        Group {
            if session.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    let session = SessionViewModel()
    let itemsVM = ItemsViewModel()
    return ContentView()
        .environmentObject(session)
        .environmentObject(itemsVM)
}
