//
//  Item.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
