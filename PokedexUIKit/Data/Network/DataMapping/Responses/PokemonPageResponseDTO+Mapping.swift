//
//  PokemonPageResponseDTO.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 11/04/25.
//

import Foundation

struct PokemonPageResponseDTO: Codable {
    
    let results: [PokemonOverview]
    
}

extension PokemonPageResponseDTO {
    
    func toDomain() -> [PokemonOverview] {
        return results
    }
    
}
