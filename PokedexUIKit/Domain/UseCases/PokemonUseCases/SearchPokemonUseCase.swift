//
//  SearchPokemonUseCase.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import RxSwift
import RxCocoa

protocol SearchPokemonUseCaseProtocol {
    func execute(with query: String) -> Single<Pokemon>
}

final class SearchPokemonUseCase {
    
    private let pokemonRepository: PokemonRepositoryProtocol
    
    init(
        pokemonRepository: PokemonRepositoryProtocol = PokemonRepository()
    ) {
        self.pokemonRepository = pokemonRepository
    }
    
}

extension SearchPokemonUseCase: SearchPokemonUseCaseProtocol {
    
    func execute(with query: String) -> Single<Pokemon> {
        pokemonRepository.fetchPokemonSearchResultList(with: query)
    }
    
}
