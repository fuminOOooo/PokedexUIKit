//
//  ProfileViewModel.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 18/04/25.
//

import RxSwift
import RxCocoa

protocol ProfileViewModelInputProtocol {
    func viewDidLoad()
    func deleteAccount()
}

protocol ProfileViewModelOutputProtocol {
    var username: String { get }
    var deleteResults: Observable<Bool> { get }
    
    var error: BehaviorRelay<Error?> { get }
}

typealias ProfileViewModelProtocol = ProfileViewModelInputProtocol & ProfileViewModelOutputProtocol

final class ProfileViewModel: ProfileViewModelProtocol {
    
    private let deleteRelay: BehaviorRelay<Bool> = .init(value: false)
    private let deleteUseCase: DeleteUseCaseProtocol
    private let bag: DisposeBag
    
    // MARK: - Output
    
    let username: String
    var deleteResults: Observable<Bool> { return deleteRelay.asObservable() }
    let error: BehaviorRelay<Error?> = .init(value: nil)
    
    // MARK: - Init
    init(
        username: String,
        deleteUseCase: DeleteUseCase = DeleteUseCase(),
        bag: DisposeBag = .init()
    ) {
        self.username = username
        self.deleteUseCase = deleteUseCase
        self.bag = bag
    }
    
}

extension ProfileViewModel {
    
    func viewDidLoad() {
        
    }
    
    func deleteAccount() {
        
        deleteUseCase.execute(with: username)
            .subscribe(
                onSuccess: { [weak self] success in
                    guard let self else { return }
                    deleteRelay.accept(success)
                },
                onFailure: { [weak self] error in
                    guard let self else { return }
                    self.error.accept(error)
                },
                onDisposed: {
                
                }
            )
            .disposed(by: bag)

    }
    
}
