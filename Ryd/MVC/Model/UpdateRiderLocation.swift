//
//  UpdateRiderLocation.swift
//  Ryd
//
//  Created by Rakib Rz  on 03/11/22.
//

import Foundation


struct UpdateRiderLocation: Codable {
    var driver, user: AppLocation?
    var trip_id: Int?
}

struct AppLocation: Codable {
    let lat, lng: String?
}
