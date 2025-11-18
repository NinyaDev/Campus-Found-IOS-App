//
//  ItemsViewModel.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import Foundation
import CoreLocation
import Combine

class ItemsViewModel: ObservableObject {
    @Published var items: [LostFoundItem] = []
    @Published var searchText: String = ""
    @Published var selectedStatus: ItemStatus? = nil
    @Published var selectedBuilding: String? = nil

    init() {
        seedFakeData()
    }

    var filteredItems: [LostFoundItem] {
        items.filter { item in
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                let text = (item.title + " " + item.description).lowercased()
                matchesSearch = text.contains(searchText.lowercased())
            }

            let matchesStatus = selectedStatus == nil || item.status == selectedStatus
            let matchesBuilding = selectedBuilding == nil || item.building == selectedBuilding

            return matchesSearch && matchesStatus && matchesBuilding
        }
        .sorted(by: { $0.date > $1.date })
    }

    func addItem(title: String,
                 description: String,
                 building: String,
                 status: ItemStatus,
                 ownerEmail: String) {
        let newItem = LostFoundItem(
            id: UUID().uuidString,
            title: title,
            description: description,
            building: building,
            status: status,
            date: Date(),
            imageURL: nil,
            ownerEmail: ownerEmail,
            location: nil
        )
        items.append(newItem)
    }

    func markReturned(_ item: LostFoundItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].status = .returned
        }
    }

    private func seedFakeData() {
        items = [
            LostFoundItem(
                id: UUID().uuidString,
                title: "AirPods case",
                description: "White AirPods case with a small red sticker",
                building: "Geoscience Building",
                status: .found,
                date: Date().addingTimeInterval(-60 * 60),
                imageURL: nil,
                ownerEmail: "ethan@suu.edu",
                location: nil
            ),
            LostFoundItem(
                id: UUID().uuidString,
                title: "Student ID Card",
                description: "SUU ID, name: Maya, dropped near Geoscience",
                building: "Geoscience Building",
                status: .lost,
                date: Date().addingTimeInterval(-2 * 60 * 60),
                imageURL: nil,
                ownerEmail: "maya@suu.edu",
                location: nil
            )
        ]
    }
}
