//
//  Models.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//
import Foundation
import CoreLocation

enum ItemStatus: String, CaseIterable, Identifiable {
    case lost = "Lost"
    case found = "Found"
    case returned = "Returned"
    case withdrawn = "Withdrawn"

    var id: String { rawValue }
}

struct LostFoundItem: Identifiable {
    let id: String
    var title: String
    var description: String
    var building: String
    var status: ItemStatus
    var date: Date
    var imageURL: String?
    var ownerEmail: String
    var location: CLLocationCoordinate2D?
}
