//
//  NewPostView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//
import SwiftUI

struct NewPostView: View {
    @EnvironmentObject var itemsVM: ItemsViewModel
    @EnvironmentObject var session: SessionViewModel

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var building: String = "Geoscience Building"
    @State private var status: ItemStatus = .lost
    @State private var showConfirmation = false

    let buildings = [
        "Geoscience Building",
        "Library",
        "Student Center",
        "Gym",
        "Business Building"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Type")) {
                    Picker("Status", selection: $status) {
                        Text("Lost").tag(ItemStatus.lost)
                        Text("Found").tag(ItemStatus.found)
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Item details")) {
                    TextField("Title (e.g., AirPods case)", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)

                    Picker("Building", selection: $building) {
                        ForEach(buildings, id: \.self) { b in
                            Text(b).tag(b)
                        }
                    }
                }

                Section(header: Text("Photo")) {
                    Text("Photo picker coming soon (placeholder).")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Section {
                    Button("Post") {
                        itemsVM.addItem(
                            title: title,
                            description: description,
                            building: building,
                            status: status,
                            ownerEmail: session.email
                        )
                        clearForm()
                        showConfirmation = true
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
            .navigationTitle("New Post")
            .alert("Post created", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your item has been added to the campus feed.")
            }
        }
    }

    private func clearForm() {
        title = ""
        description = ""
        building = "Geoscience Building"
        status = .lost
    }
}



