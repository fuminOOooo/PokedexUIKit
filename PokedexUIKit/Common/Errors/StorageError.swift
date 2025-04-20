//
//  StorageError.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

enum StorageError: String, Error {
    case failedFetching = "Failed fetching from Realm"
    case failedSaving = "Failed saving on Realm"
    case failedDeleting = "Failed deleting on Realm"
}
