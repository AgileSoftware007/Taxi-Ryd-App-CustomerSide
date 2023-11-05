// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let socketModel = try? newJSONDecoder().decode(SocketModel.self, from: jsonData)

import Foundation

// MARK: - SocketModel
struct SocketModel: Equatable {
    var lng, socketID, id, lat: String?
    let busy: Bool?
    var distance: Double?

    
}
