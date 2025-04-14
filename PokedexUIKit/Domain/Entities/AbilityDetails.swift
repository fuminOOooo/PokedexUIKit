//
//  AbilityDetails.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

struct AbilityDetails: Codable, Equatable {
    
    let ability: Ability?
    let isHidden: Bool?
    let slot: Int?
    
    init(
        ability: Ability?,
        isHidden: Bool?,
        slot: Int?
    ) {
        self.ability = ability
        self.isHidden = isHidden
        self.slot = slot
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ability = try container.decodeIfPresent(Ability.self, forKey: .ability)
        self.isHidden = try container.decodeIfPresent(Bool.self, forKey: .isHidden)
        self.slot = try container.decodeIfPresent(Int.self, forKey: .slot)
    }
    
    private enum CodingKeys: String, CodingKey {
        case ability, slot
        case isHidden = "is_hidden"
    }
    
}
