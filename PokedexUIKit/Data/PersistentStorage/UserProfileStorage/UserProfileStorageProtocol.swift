//
//  UserProfile.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift

protocol UserProfileStorageProtocol {
    func loginCheck(with profile: UserProfile) -> Single<Bool>
    func saveUser(with profile: UserProfile) -> Single<Bool>
    func deleteUser(with username: String) -> Single<Bool>
}
