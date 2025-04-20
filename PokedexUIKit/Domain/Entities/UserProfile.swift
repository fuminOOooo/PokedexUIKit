//
//  UserProfile.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RealmSwift

class UserProfile: Object {
    @Persisted var username: String
    @Persisted var password: String
}
