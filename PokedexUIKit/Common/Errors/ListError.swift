//
//  ListError.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 20/04/25.
//

enum ListError: String, Error {
    case loadingListFailed = "Failed to load more Pokemon. Swipe down on list to retry."
}
