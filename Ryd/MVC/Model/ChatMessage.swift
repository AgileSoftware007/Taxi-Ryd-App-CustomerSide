//
//  ChatMessage.swift
//  Ryd
//
//  Created by Rakib Rz  on 31/10/22.
//

import Foundation

struct ChatMessage: Codable {
    var id, tripId, senderId, receiverId: Int?
    var message, created, modified: String?

    enum CodingKeys: String, CodingKey {
        case id, message, created, modified
        case tripId = "trip_id"
        case senderId = "from_id"
        case receiverId = "to_id"
    }
    
    func getTime() -> String? {
        guard let created else {
            return ""
        }
        let date = Date.convertFrom(string: created, format: .yyyyddmmhhmmss)
        return date?.getTime()
    }
}
