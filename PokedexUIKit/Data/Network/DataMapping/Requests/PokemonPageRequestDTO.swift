//
//  PokemonPageRequestDTO.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import Foundation

struct PokemonPageRequestDTO: Encodable {
    let offset: Int
    let limit: Int = Constants.apiLimit
}
