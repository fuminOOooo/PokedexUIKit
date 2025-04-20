//
//  UserProfileRepository.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift

final class UserProfileRepository {
    
    private let userProfileStorage: UserProfileStorageProtocol
    
    init(userProfileStorage: UserProfileStorageProtocol = UserProfileRealmStorage()) {
        self.userProfileStorage = userProfileStorage
    }
    
}

extension UserProfileRepository: UserProfileRepositoryProtocol {
    
    func registerNewUser(with profile: UserProfile) -> Single<Bool> {
        userProfileStorage.saveUser(with: profile)
    }
    
    func loginRegisteredUser(with profile: UserProfile) -> Single<Bool> {
        userProfileStorage.loginCheck(with: profile)
    }
    
    func deleteRegisteredUser(with username: String) -> Single<Bool> {
        userProfileStorage.deleteUser(with: username)
    }
    
}
