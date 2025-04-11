//
//  PokemonAPIRouter.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import Alamofire

enum PokemonAPIRouter: HTTPRouterProtocol {
    
    case fetchPokemonPage(request: PokemonPageRequestDTO)
    case fetchPokemonSearch(request: PokemonSearchRequestDTO)
    
    var baseURLString: String {
        return "https://pokeapi.co/api/v2"
    }
    
    var path: String {
        switch self {
        case .fetchPokemonPage:
            return "pokemon"
        case .fetchPokemonSearch(let request):
            return "pokemon/\(request.query)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: Parameters {
        switch self {
        case .fetchPokemonPage(let request):
            return ["offset": request.offset, "limit": request.limit]
        case .fetchPokemonSearch(let request):
            return [:]
        }
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}
