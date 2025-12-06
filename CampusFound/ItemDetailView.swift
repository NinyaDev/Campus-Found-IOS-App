import SwiftUI
import CoreLocation

struct ItemDetailView: View {
    let item: LostFoundItem
    @EnvironmentObject var itemsVM: ItemsViewModel

    @State private var showingMessageSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                photoArea
                headerArea
                locationSection
                Divider()
                descriptionSection
                Divider()
                actionButtons
            }
            .padding()
        }
        .navigationTitle("Item Details")
        .sheet(isPresented: $showingMessageSheet) {
            MessageSheetView(item: item)
        }
    }

    // MARK: - Subviews

    private var photoArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 220)

            if let urlString = item.imageURL,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .clipped()
                            .cornerRadius(16)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(height: 220)
            } else {
                placeholderImage
            }
        }
    }

    private var headerArea: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)

            HStack {
                Text(item.status.rawValue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Spacer()

                Text(item.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Location")
                .font(.headline)

            Text(item.building)
                .font(.subheadline)

            if let loc = item.location {
                Text("Shared exact location:")
                    .font(.subheadline)

                Text("Lat \(loc.latitude, specifier: "%.5f"), Lng \(loc.longitude, specifier: "%.5f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("No precise location shared")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var descriptionSection: some View {
        Text(item.description)
            .font(.body)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                showingMessageSheet = true
            } label: {
                Text("Message to claim / verify")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button {
                itemsVM.markReturned(item)
            } label: {
                Text("Mark as Returned")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
        }
    }

    // MARK: - Helpers

    private var placeholderImage: some View {
        Image(systemName: "photo.on.rectangle.angled")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}
