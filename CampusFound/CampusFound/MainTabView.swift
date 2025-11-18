//
//  MainTabView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet.rectangle")
                }

            NewPostView()
                .tabItem {
                    Label("New", systemImage: "plus.circle.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
