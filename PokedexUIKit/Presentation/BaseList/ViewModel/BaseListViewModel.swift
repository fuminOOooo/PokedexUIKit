//
//  BaseListViewModel.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import RxSwift
import RxCocoa

protocol BaseListViewModelInputProtocol {
    func viewDidLoad()
    func loadPokemonPage()
}

protocol BaseListViewModelOutputProtocol {
    var items: Observable<[PokemonOverview]> { get }
    var query: BehaviorRelay<String> { get }
    var error: PublishSubject<String> { get }
    var isButtonEnabled: Observable<Bool> { get }
}

typealias BaseListViewModelProtocol = BaseListViewModelInputProtocol & BaseListViewModelOutputProtocol

final class BaseListViewModel: BaseListViewModelProtocol {
    
    private let loadPokemonUseCase: LoadPokemonUseCaseProtocol
    private let itemsRelay: BehaviorRelay<[PokemonOverview]> = .init(value: [])
    private let bag: DisposeBag
    
    var currentPage: Int = 0
    
    // MARK: - Output
    var items: Observable<[PokemonOverview]> { return itemsRelay.asObservable() }
    var query: BehaviorRelay<String> = .init(value: .init())
    var error: PublishSubject<String> = .init()
    var isButtonEnabled: Observable<Bool> {
        return query.asObservable()
            .map { query in
                return !query.isEmpty
            }
    }
    
    // MARK: - Init
    init(
        loadPokemonUseCase: LoadPokemonUseCaseProtocol = LoadPokemonUseCase(),
        bag: DisposeBag = DisposeBag()
    ) {
        self.loadPokemonUseCase = loadPokemonUseCase
        self.bag = bag
    }
    
    // MARK: - Private
    private func getPageOffset() -> Int {
        return currentPage * Constants.apiLimit
    }
    
    private func appendItems(with value: [PokemonOverview]) {
        let appendedItems = itemsRelay.value + value
        itemsRelay.accept(appendedItems)
    }
    
    private func incrementPage() {
        currentPage += 1
    }
    
}

extension BaseListViewModel {
    
    // MARK: - Input
    
    func viewDidLoad() {
        
        self.loadPokemonPage()
        
    }
    
    func loadPokemonPage() {
        
        loadPokemonUseCase.execute(with: getPageOffset())
            .subscribe(
                onSuccess: { [weak self] results in
                    guard let self else { return }
                    appendItems(with: results)
                    incrementPage()
                },
                onFailure: { error in
                    // TODO: Handle Pokemon Page Loading Error
                }
            )
            .disposed(by: bag)
        
    }
    
}
