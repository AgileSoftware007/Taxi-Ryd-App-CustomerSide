//
//  UpdateEmailResponse.swift
//  Ryd Driver
//
//  Created by Prepladder on 01/05/21.
//  Copyright © 2021 Harsh. All rights reserved.
//


import Foundation

// MARK: - UpdateEmailResponse
struct UpdateEmailResponse: Codable {
    let status: Bool?
    let message: String?
    let user: User?
}
