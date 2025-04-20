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
    var queryRelay: BehaviorRelay<String> { get }
    var isButtonEnabled: Observable<Bool> { get }
    
    var error: BehaviorRelay<ListError?> { get }
}

typealias BaseListViewModelProtocol = BaseListViewModelInputProtocol & BaseListViewModelOutputProtocol

final class BaseListViewModel: BaseListViewModelProtocol {
    
    private let loadPokemonUseCase: LoadPokemonUseCaseProtocol
    private let itemsRelay: BehaviorRelay<[PokemonOverview]> = .init(value: [])
    private let bag: DisposeBag
    
    var currentPage: Int = 0
    
    // MARK: - Output
    let queryRelay: BehaviorRelay<String> = .init(value: .init())
    var items: Observable<[PokemonOverview]> {
        return itemsRelay.asObservable()
    }
    var isButtonEnabled: Observable<Bool> {
        return queryRelay.asObservable()
            .map { query in
                return !query.isEmpty
            }
    }
    
    let error: BehaviorRelay<ListError?> = .init(value: nil)
    
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
                onFailure: { [weak self] error in
                    guard
                        let self,
                        let error = error as? ListError
                    else { return }
                    self.error.accept(error)
                }
            )
            .disposed(by: bag)
        
    }
    
}
