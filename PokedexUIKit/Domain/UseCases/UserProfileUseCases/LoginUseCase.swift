//
//  LoginUseCase.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift

protocol LoginUseCaseProtocol {
    func execute(with profile: UserProfile) -> Single<Bool>
}

final class LoginUseCase {
    
    private let userProfileRepository: UserProfileRepositoryProtocol
    
    init(
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()
    ) {
        self.userProfileRepository = userProfileRepository
    }
    
}

extension LoginUseCase: LoginUseCaseProtocol {
    
    func execute(with profile: UserProfile) -> Single<Bool> {
        userProfileRepository.loginRegisteredUser(with: profile)
    }
    
}
