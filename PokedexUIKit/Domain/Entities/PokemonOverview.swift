//
//  PokemonOverview.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 11/04/25.
//

import Foundation

struct PokemonOverview: Codable, Identifiable {
    
    let id: UUID
    let name: String?
    let url: String?
    
    init(name: String?, url: String?) {
        self.id = UUID()
        self.name = name
        self.url = url
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, url
    }
    
}
