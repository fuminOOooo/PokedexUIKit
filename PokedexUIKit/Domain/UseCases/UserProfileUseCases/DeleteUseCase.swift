//
//  DeleteUseCase.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 20/04/25.
//

import RxSwift

protocol DeleteUseCaseProtocol {
    func execute(with username: String) -> Single<Bool>
}

final class DeleteUseCase {
    
    private let userProfileRepository: UserProfileRepositoryProtocol
    
    init(
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()
    ) {
        self.userProfileRepository = userProfileRepository
    }
    
}

extension DeleteUseCase: DeleteUseCaseProtocol {
    
    func execute(with username: String) -> Single<Bool> {
        userProfileRepository.deleteRegisteredUser(with: username)
    }
    
}
