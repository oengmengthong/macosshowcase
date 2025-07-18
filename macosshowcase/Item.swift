//
//  Item.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
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
