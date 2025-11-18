//
//  CampusFoundApp.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import SwiftUI

@main
struct CampusFoundApp: App {
    @StateObject private var session = SessionViewModel()
    @StateObject private var itemsVM = ItemsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
                .environmentObject(itemsVM)
        }
    }
}
