//
//  EndPoint.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import Foundation

struct Endpoint: Endpointable {
    var baseURL: URL
    var method: HTTPMethod
    var paths: String?
    var queries: [String : String]?
    var body: [String : Any]?
    var headers: HTTPHeaders
    
    init(baseURL: String? = nil,
         method: HTTPMethod = .GET,
         paths: String?,
         queries: [String : String]? = nil,
         body: [String : Any]? = nil) {
        let defaultUrl = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
        self.baseURL = URL(string: baseURL ?? defaultUrl)!
        self.method = method
        self.paths = paths
        self.queries = queries
        self.body = body
        self.headers = ["Content-Type": "application/json",
                        "Accept" : "*/*"]
    }
    
    func setHeaders(_ newHeaders: HTTPHeaders) -> Self {
        var newEndpoint = self
        
        newHeaders.forEach {
            newEndpoint.headers[$0.key] = $0.value
        }
        
        return newEndpoint
    }
    
    func setAccessToken() -> Self {
        var newEndpoint = self
        guard let accessToken = KeychainManager.read("accessToken")
        else { return self }
        
        newEndpoint.headers["Authorization"] = "Bearer \(accessToken)"
        
        return newEndpoint
    }
}
