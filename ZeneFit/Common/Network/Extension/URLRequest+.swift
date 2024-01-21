//
//  URLRequest+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/15.
//

import Foundation

extension URLRequest {
    func setMethod(_ method: HTTPMethod) -> URLRequest {
        var urlRequest = self
        
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    func setPaths(_ paths: String?) -> Self {
        guard let paths = paths,
              let url = self.url
        else { return self }
        var request = self
        request.url = url.appendingPathComponent(paths)
        return request
    }
    
    func appendingHeaders(_ headers: HTTPHeaders) -> URLRequest {
        var urlRequest = self
        
        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
    
    func setBody(at body: [String : Any]?) -> URLRequest {
        var urlRequest = self
        if let body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return urlRequest
    }
    
    func setBody(at body: Encodable?) -> URLRequest {
        var urlRequest = self
        if let body {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        
        return urlRequest
    }
    
    func setQueries(_ queries: [String: String]?) -> Self {
        guard let queries = queries,
              let urlString = self.url?.absoluteString,
              var components = URLComponents(string: urlString)
        else { return self }
        
        var request = self
        components.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        request.url = components.url
        
        return request
    }
    
    func setHeaders(_ headers: [String : String]) -> Self {
        var new = self
        new.allHTTPHeaderFields = headers
        return new
    }
}
