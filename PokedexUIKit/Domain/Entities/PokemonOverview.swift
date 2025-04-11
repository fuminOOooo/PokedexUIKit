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
    
    init(name: String, url: String) {
        self.id = UUID()
        self.name = nameFormatter(name)
        self.url = url
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        let rawName = try container.decodeIfPresent(String.self, forKey: .name)
        self.name = nameFormatter(rawName ?? .init())
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, url
    }
    
}

private let nameFormatter: (String) -> String = { name in
    
    return name
        .replacingOccurrences(of: "-", with: " ")
        .capitalized
    
}
