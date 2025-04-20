//
//  PokemonRepository.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import RxSwift

final class PokemonRepository: PokemonRepositoryProtocol {
    
    private let httpService: HTTPServiceProtocol
    
    init(httpService: HTTPServiceProtocol = HTTPService()) {
        self.httpService = httpService
    }
    
    func fetchPokemonPageResultList(with offset: Int) -> Single<[PokemonOverview]> {
        
        let dto = PokemonPageRequestDTO(offset: offset)
        let router = PokemonAPIRouter.fetchPokemonPage(request: dto)
        
        return Single.create { single in
            
            do {
            
                let request = try router.asURLRequest()
                let dataRequest = self.httpService
                    .request(request)
                    .responseDecodable(of: PokemonPageResponseDTO.self) { response in
                        switch response.result {
                        case .success(let responseDTO):
                            return single(.success(responseDTO.toDomain()))
                        case .failure(_):
                            return single(.failure(ListError.loadingListFailed))
                        }
                    }
                
                return Disposables.create { dataRequest.cancel() }
                
            } catch (let error) {
                
                single(.failure(error))
                return Disposables.create()
                
            }
            
        }
        
    }
    
    func fetchPokemonSearchResultList(with name: String) -> Single<Pokemon> {
        
        let dto = PokemonSearchRequestDTO(query: name)
        let router = PokemonAPIRouter.fetchPokemonSearch(request: dto)
        
        return Single.create { single in
            
            do {
            
                let request = try router.asURLRequest()
                let dataRequest = self.httpService
                    .request(request)
                    .responseDecodable(of: PokemonSearchResponseDTO.self) { response in
                        switch response.result {
                        case .success(let responseDTO):
                            return single(.success(responseDTO.toDomain()))
                        case .failure(_):
                            return single(.failure(DetailsError.failedLodingDetails))
                        }
                    }
                
                return Disposables.create { dataRequest.cancel() }
                
            } catch (let error) {
                
                single(.failure(error))
                return Disposables.create()
                
            }
            
        }
        
    }
    
}
