//
//  Ability.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 11/04/25.
//

struct Ability: Codable, Equatable {
    
    let name: String?
    let url: String?
    
    init(
        name: String?,
        url: String?
    ) {
        self.name = name
        self.url = url
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, url
    }
    
}
