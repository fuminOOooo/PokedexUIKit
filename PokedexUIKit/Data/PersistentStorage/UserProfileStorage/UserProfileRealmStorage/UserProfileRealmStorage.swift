//
//  UserProfileRealmStorage.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift

final class UserProfileRealmStorage {
    
    private let realmStorage: RealmStorage
    
    init(realmStorage: RealmStorage = .shared) {
        self.realmStorage = realmStorage
    }
    
}

extension UserProfileRealmStorage: UserProfileStorageProtocol {
    
    func loginCheck(with profile: UserProfile) -> Single<Bool> {
        
        return Single.create { single in
            
            guard let userProfiles: [UserProfile] = self.realmStorage.fetch(ofType: UserProfile.self)
            else {
                
                single(.failure(AuthenticationError.failedLogin))
                return Disposables.create()
                
            }
            
            let flag: Bool = userProfiles.contains { fetched in
                (profile.username == fetched.username) && (profile.password == fetched.password)
            }
            
            flag ? single(.success(flag)) : single(.failure(AuthenticationError.accountNotFound))
            
            return Disposables.create()
            
        }
        
    }
    
    func saveUser(with profile: UserProfile) -> Single<Bool> {
        
        return Single.create { single in
            
            guard let userProfiles: [UserProfile] = self.realmStorage.fetch(ofType: UserProfile.self)
            else {
                
                single(.failure(AuthenticationError.failedRegistering))
                return Disposables.create()
                
            }
            
            let exists: Bool = userProfiles.contains { fetched in
                (profile.username == fetched.username)
            }
            
            if exists {
                single(.failure(AuthenticationError.accountExists))
            } else {
                let status = self.realmStorage.store(object: profile)
                single(.success(status))
            }
            
            return Disposables.create()
            
        }
        
    }
    
    func deleteUser(with username: String) -> Single<Bool> {
        
        return Single.create { single in
            
            guard let userProfiles: [UserProfile] = self.realmStorage.fetch(ofType: UserProfile.self)
            else {
                
                single(.failure(AuthenticationError.failedDeleting))
                return Disposables.create()
                
            }
            
            guard let profile: UserProfile = userProfiles.first(where: { $0.username == username }) else {
                
                single(.failure(AuthenticationError.failedDeleting))
                return Disposables.create()
                
            }
            
            let status = self.realmStorage.deleteSingleObject(object: profile)
            
            status ? single(.success(status)) : single(.failure(AuthenticationError.failedDeleting))
            
            return Disposables.create()
            
        }
        
    }
    
}
