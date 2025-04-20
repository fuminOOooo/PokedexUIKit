//
//  LoadPokemonUseCase.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import RxSwift
import RxCocoa

protocol LoadPokemonUseCaseProtocol {
    func execute(with offset: Int) -> Single<[PokemonOverview]>
}

final class LoadPokemonUseCase {
    
    private let pokemonRepository: PokemonRepositoryProtocol
    
    init(
        pokemonRepository: PokemonRepositoryProtocol = PokemonRepository()
    ) {
        self.pokemonRepository = pokemonRepository
    }
    
}

extension LoadPokemonUseCase: LoadPokemonUseCaseProtocol {
    
    func execute(with offset: Int) -> Single<[PokemonOverview]> {
        pokemonRepository.fetchPokemonPageResultList(with: offset)
    }
    
}
