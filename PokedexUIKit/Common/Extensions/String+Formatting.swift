//
//  String+Formatting.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 14/04/25.
//

extension Optional where Wrapped == String {
    
    func formattedForName() -> String? {
        guard let self else { return self }
        return self
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
    }
    
}
