//
//  RecoveryPassword.swift
//  Ryd Driver
//
//  Created by Prepladder on 24/04/21.
//  Copyright © 2021 Harsh. All rights reserved.
//

import Foundation


// MARK: - ForgotPasswordResponse
struct ForgotPasswordResponse: Codable {
    let status: Bool?
    let message, token, otp: String?
    let user : User?
}


// MARK: - ForgotPasswordVerify
struct ForgotPasswordVerify: Codable {
    let status: Bool?
    let message, token: String?
    let user : User?
}


// MARK: - RecoverPassword
struct RecoverPassword: Codable {
    let status: Bool?
    let message: String?
    let user : User?
}

