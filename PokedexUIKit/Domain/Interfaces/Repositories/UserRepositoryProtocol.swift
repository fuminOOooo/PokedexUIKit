//
//  UserRepositoryProtocol.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RxSwift

protocol UserProfileRepositoryProtocol {
    func registerNewUser(with profile: UserProfile) -> Single<Bool>
    func loginRegisteredUser(with profile: UserProfile) -> Single<Bool>
    func deleteRegisteredUser(with username: String) -> Single<Bool>
}
