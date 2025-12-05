//
//  MessageSheetView.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 12/5/25.
//
import SwiftUI

struct MessageSheetView: View {
    let item: LostFoundItem
    @Environment(\.dismiss) private var dismiss

    @State private var messageText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Contact about")) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.building)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Your message")) {
                    TextEditor(text: $messageText)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Message owner")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        // TODO: hook into email / in-app messaging later
                        print("Message sent:", messageText)
                        dismiss()
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
