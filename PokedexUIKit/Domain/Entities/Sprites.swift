//
//  Sprites.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

struct Sprites: Codable, Equatable {
    
    let backDefault: String?
    let frontDefault: String?
    
    init(backDefault: String?, frontDefault: String?) {
        self.backDefault = backDefault
        self.frontDefault = frontDefault
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backDefault = try container.decodeIfPresent(String.self, forKey: .backDefault)
        self.frontDefault = try container.decodeIfPresent(String.self, forKey: .frontDefault)
    }
    
    private enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case frontDefault = "front_default"
    }
    
}
