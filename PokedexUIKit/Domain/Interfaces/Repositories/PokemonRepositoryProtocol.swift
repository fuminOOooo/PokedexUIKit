//
//  PokemonRepositoryProtocol.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import RxSwift

protocol PokemonRepositoryProtocol {
    func fetchPokemonPageResultList(with offset: Int) -> Single<[PokemonOverview]>
    func fetchPokemonSearchResultList(with name: String) -> Single<Pokemon>
}
