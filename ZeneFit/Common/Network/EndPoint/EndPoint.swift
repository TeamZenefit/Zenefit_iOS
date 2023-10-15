//
//  EndPoint.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import Foundation

struct Endpoint: EndpointProtocol {
    var baseURL: URL?
    var method: HTTPMethod
    var path: String?
    var parameters: HTTPRequestParameterType?
    
    init(baseURL: String, method: HTTPMethod = .GET, path: String?, parameters: HTTPRequestParameterType? = nil) {
        self.baseURL = URL(string: baseURL)
        self.method = method
        self.path = path
        self.parameters = parameters
    }
}
