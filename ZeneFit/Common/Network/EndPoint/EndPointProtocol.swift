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

public enum HTTPRequestParameterType {
    case query([String: String])
    case body(Encodable)
}

protocol EndpointProtocol {
    var baseURL: URL? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var path: String { get }
    var parameters: HTTPRequestParameterType? { get }
    
    func toURLRequest() -> URLRequest?
}

extension EndpointProtocol {
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = configureURL() else { return nil }
        
        return URLRequest(url: url)
            .setMethod(method)
            .appendingHeaders(headers)
            .setBody(at: parameters)
    }
    
    private func configureURL() -> URL? {
        return baseURL?
            .appendingPath(path)
            .appendingQueries(at: parameters)
    }
}

extension URL {
    func appendingPath(_ path: String) -> URL {
        return self.appendingPathComponent(path)
    }
    
    func appendingQueries(at parameter: HTTPRequestParameterType?) -> URL? {
        var components = URLComponents(string: self.absoluteString)
        if case .query(let queries) = parameter {
            components?.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        }
       
        return components?.url
    }
}

extension URLRequest {
    func setMethod(_ method: HTTPMethod) -> URLRequest {
        var urlRequest = self
        
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    func appendingHeaders(_ headers: HTTPHeaders) -> URLRequest {
        var urlRequest = self
        
        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
    
    func setBody(at parameter: HTTPRequestParameterType?) -> URLRequest {
        var urlRequest = self
        
        if case .body(let body) = parameter {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        return urlRequest
    }
}
