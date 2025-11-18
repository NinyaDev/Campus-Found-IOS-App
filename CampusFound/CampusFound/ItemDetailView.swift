//
//  ItemDetailView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//
import SwiftUI

struct ItemDetailView: View {
    let item: LostFoundItem
    @EnvironmentObject var itemsVM: ItemsViewModel

    @State private var showingMessageSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                    )

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

                Text("Location: \(item.building)")
                    .font(.subheadline)

                Divider()

                Text(item.description)
                    .font(.body)

                Divider()

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
            .padding()
        }
        .navigationTitle("Item Details")
        .sheet(isPresented: $showingMessageSheet) {
            MessageSheetView(item: item)
        }
    }
}

struct MessageSheetView: View {
    let item: LostFoundItem
    @State private var messageText: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Send a message to the person who posted this item. Include details to verify that it's yours.")
                    .font(.subheadline)

                TextEditor(text: $messageText)
                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )

                Spacer()

                Button {
                    print("Message sent: \(messageText)")
                } label: {
                    Text("Send")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Message")
        }
    }
}

