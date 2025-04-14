//
//  HTTPService.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import Alamofire

protocol HTTPServiceProtocol {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}

class HTTPService: HTTPServiceProtocol {
    
    var sessionManager: Session
    
    init(sessionManager: Session = Session.default) {
        self.sessionManager = sessionManager
    }
    
}

extension HTTPService {
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        sessionManager.request(urlRequest).validate(statusCode: 200 ..< 400)
    }
    
}
