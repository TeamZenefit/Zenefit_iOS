//
//  EndPoint.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, DELETE, FETCH, PATCH
}

typealias HTTPHeaders = [String: String]

protocol Endpointable {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var paths: String? { get }
    var queries: [String : String]? { get }
    var body: [String : Any]? { get }
    var bodyWithEncodable: Encodable? { get }
    
    var request: URLRequest { get }
}

extension Endpointable {
    var request: URLRequest {
        .init(url: baseURL)
        .setMethod(method)
        .setPaths(paths)
        .setBody(at: body)
        .setBody(at: bodyWithEncodable)
        .setQueries(queries)
        .setHeaders(headers)
    }
}
