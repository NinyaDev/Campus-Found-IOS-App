//
//  FeedView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var itemsVM: ItemsViewModel

    let buildings = [
        "All", "Geoscience Building", "Library", "Student Center", "Gym"
    ]

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search (e.g., AirPods, backpack)", text: $itemsVM.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding([.horizontal, .top])

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Menu {
                            Button("Any Status") { itemsVM.selectedStatus = nil }
                            ForEach(ItemStatus.allCases) { status in
                                Button(status.rawValue) {
                                    itemsVM.selectedStatus = status
                                }
                            }
                        } label: {
                            Label(itemsVM.selectedStatus?.rawValue ?? "Status",
                                  systemImage: "line.3.horizontal.decrease.circle")
                        }

                        Menu {
                            Button("All Buildings") { itemsVM.selectedBuilding = nil }
                            ForEach(buildings, id: \.self) { building in
                                if building != "All" {
                                    Button(building) {
                                        itemsVM.selectedBuilding = building
                                    }
                                }
                            }
                        } label: {
                            Label(itemsVM.selectedBuilding ?? "Building",
                                  systemImage: "mappin.circle")
                        }
                    }
                    .padding(.horizontal)
                }

                List(itemsVM.filteredItems) { item in
                    NavigationLink {
                        ItemDetailView(item: item)
                    } label: {
                        ItemRowView(item: item)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Campus Feed")
        }
    }
}

struct ItemRowView: View {
    let item: LostFoundItem

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: item.status == .found
                          ? "magnifyingglass.circle.fill"
                          : "exclamationmark.circle.fill")
                        .font(.title2)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.building)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(item.status.rawValue)
                    .font(.caption)
                    .foregroundColor(item.status == .found ? .green :
                                        (item.status == .lost ? .red : .gray))
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
