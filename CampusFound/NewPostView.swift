//
//  NewPostView.swift
//  CampusFound
//
//  Created by Adrian Ninanya and Andres Eguez on 11/17/25.
//
import SwiftUI
import PhotosUI

struct NewPostView: View {
    @EnvironmentObject var itemsVM: ItemsViewModel
    @EnvironmentObject var session: SessionViewModel

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var building: String = "Geoscience Building"
    @State private var status: ItemStatus = .lost
    @State private var showConfirmation = false

    // PHOTO
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    // LOCATION
    @StateObject private var locationManager = LocationManager()
    @State private var shareLocation: Bool = false

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
                typeSection
                detailsSection
                photoSection
                locationSection
                submitSection
            }
            .navigationTitle("New Post")
            .alert("Post created", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your item has been added to the campus feed.")
            }
        }
        // Load image data when picker changes
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else {
                selectedImageData = nil
                return
            }

            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        selectedImageData = data
                    }
                }
            }
        }
    }

    // MARK: - Sections

    private var typeSection: some View {
        Section(header: Text("Type")) {
            Picker("Status", selection: $status) {
                Text("Lost").tag(ItemStatus.lost)
                Text("Found").tag(ItemStatus.found)
            }
            .pickerStyle(.segmented)
        }
    }

    private var detailsSection: some View {
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
    }

    private var photoSection: some View {
        Section(header: Text("Photo")) {
            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Add photo", systemImage: "photo.on.rectangle")
            }

            if let data = selectedImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Text("No photo selected yet")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var locationSection: some View {
        Section(header: Text("Location")) {
            Toggle("Share my current location", isOn: $shareLocation)
                .onChange(of: shareLocation) { _, newValue in
                    if newValue {
                        locationManager.requestLocationOnce()
                    }
                }

            if shareLocation {
                if locationManager.isRequesting {
                    HStack {
                        ProgressView()
                        Text("Getting your location…")
                    }
                    .font(.footnote)
                } else if let loc = locationManager.lastLocation {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Location captured:")
                        Text("Lat \(loc.coordinate.latitude, specifier: "%.5f"), Lng \(loc.coordinate.longitude, specifier: "%.5f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else if let error = locationManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                } else {
                    Text("Turn on location to attach where you found the item.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Location is optional. You can still post without sharing it.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var submitSection: some View {
        Section {
            Button("Post") {
                let coord: CLLocationCoordinate2D? =
                    (shareLocation && locationManager.lastLocation != nil)
                    ? locationManager.lastLocation!.coordinate
                    : nil

                itemsVM.addItem(
                    title: title,
                    description: description,
                    building: building,
                    status: status,
                    ownerEmail: session.email,
                    imageURL: nil,
                    imageData: selectedImageData,
                    location: coord
                )

                clearForm()
                showConfirmation = true
            }
            .disabled(title.isEmpty || description.isEmpty)
        }
    }

    // MARK: - Helpers

    private func clearForm() {
        title = ""
        description = ""
        building = "Geoscience Building"
        status = .lost
        selectedPhotoItem = nil
        selectedImageData = nil
        shareLocation = false
    }
}
