//
//  RegisterUseCase.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift

protocol RegisterUseCaseProtocol {
    func execute(with profile: UserProfile) -> Single<Bool>
}

final class RegisterUseCase {
    
    private let userProfileRepository: UserProfileRepositoryProtocol
    
    init(
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()
    ) {
        self.userProfileRepository = userProfileRepository
    }
    
}

extension RegisterUseCase: RegisterUseCaseProtocol {
    
    func execute(with profile: UserProfile) -> Single<Bool> {
        userProfileRepository.registerNewUser(with: profile)
    }
    
}
