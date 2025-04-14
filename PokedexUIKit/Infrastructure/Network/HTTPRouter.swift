//
//  HTTPRouter.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 10/04/25.
//

import Alamofire

protocol HTTPRouterProtocol {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters { get }
    func body() throws -> Data?
    func asURLRequest() throws -> URLRequest
}

extension HTTPRouterProtocol {
    
    var parameters: Parameters { return [:] }
    func body() throws -> Data? { return nil }
    
    func asURLRequest() throws -> URLRequest {
        
        var url = try baseURLString.asURL()
        url.append(path: path)
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        return try URLEncoding.default.encode(request, with: parameters)
        
    }
    
}
