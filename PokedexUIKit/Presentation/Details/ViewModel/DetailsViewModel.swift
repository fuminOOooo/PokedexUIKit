//
//  DetailsViewModel.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 14/04/25.
//

import RxSwift
import RxCocoa

protocol DetailsViewModelInputProtocol {
    func viewDidLoad()
    func loadPokemonDetails()
}

protocol DetailsViewModelOutputProtocol {
    var details: Observable<Pokemon> { get }
    var abilities: Observable<[AbilityDetails]> { get }
}

typealias DetailsViewModelProtocol = DetailsViewModelInputProtocol & DetailsViewModelOutputProtocol

final class DetailsViewModel: DetailsViewModelProtocol {
    
    private let searchPokemonUseCase: SearchPokemonUseCaseProtocol
    private let bag: DisposeBag
    private let detailsRelay: BehaviorRelay<Pokemon>
    
    private let query: String
    
    // MARK: - Output
    var details: Observable<Pokemon> { return detailsRelay.asObservable() }
    var abilities: Observable<[AbilityDetails]> {
        return detailsRelay
            .compactMap { $0 }
            .map {
                guard let abilities = $0.abilities else { return [] }
                return abilities
            }
    }
    
    init(
        query: String,
        searchPokemonUseCase: SearchPokemonUseCaseProtocol = SearchPokemonUseCase(),
        bag: DisposeBag = DisposeBag()
    ) {
        
        self.query = query
        self.searchPokemonUseCase = searchPokemonUseCase
        
        let emptyDetails = Pokemon(
            id: nil,
            name: nil,
            abilities: nil,
            sprites: nil
        )
        
        self.detailsRelay = .init(
            value: emptyDetails
        )
        
        self.bag = bag
        
    }
    
}

extension DetailsViewModel {
    
    // MARK: - Input
    
    func viewDidLoad() {
        loadPokemonDetails()
    }
    
    func loadPokemonDetails() {
        searchPokemonUseCase.execute(with: query)
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let self else { return }
                    detailsRelay.accept(result)
                }, onFailure: { error in
                    // TODO: Handle Pokemon Search Loading Error
                }
            )
            .disposed(by: bag)
    }
    
}
