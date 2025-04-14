//
//  Pokemon.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

struct Pokemon: Codable, Equatable {
    
    typealias Identifier = Int
    let id: Identifier?
    let name: String?
    let abilities: [AbilityDetails]?
    let sprites: Sprites?
    
    init(
        id: Int?,
        name: String?,
        abilities: [AbilityDetails]?,
        sprites: Sprites?
    ) {
        self.id = id
        self.name = name
        self.abilities = abilities
        self.sprites = sprites
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.abilities = try container.decodeIfPresent([AbilityDetails].self, forKey: .abilities)
        self.sprites = try container.decodeIfPresent(Sprites.self, forKey: .sprites)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, abilities, sprites
    }
    
}
