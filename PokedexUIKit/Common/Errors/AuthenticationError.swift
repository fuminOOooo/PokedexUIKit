//
//  AuthenticationError.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 16/04/25.
//

enum AuthenticationError: String, Error {
    
    case failedLogin = "Failed logging in. Please try again."
    case accountNotFound = "Account with that Username or Password not found."
    
    case failedRegistering = "Failed to create user. Please try again."
    case accountExists = "Account with the same username exists."
    
    case failedDeleting = "Failed to delete user. Please try again."
    
}
