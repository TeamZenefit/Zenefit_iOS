//
//  URLSession+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/16.
//

import Foundation
import Combine

extension URLSession: URLSessionable {
    static var defaultResponseHandler: ((HTTPURLResponse) throws -> Void) {{ res in
        guard (200...299).contains(res.statusCode) else {
            print("HTTP Error: \(res.statusCode)")
            throw CommonError.serverError
        }
    }}
    
    func dataTaskPublisher<T>(
        urlRequest: URLRequest,
        expect type: T.Type,
        responseHandler: ((_ response: HTTPURLResponse) throws -> Void)? = nil)
    -> AnyPublisher<T, Error> where T: Decodable {
        #if DEBUG
        logRequestInfo(urlRequest)
        #endif
        return self.dataTaskPublisher(for: urlRequest)
            .tryMap { [weak self] (data, response) -> Data in
                guard let res = response as? HTTPURLResponse else {
                    throw CommonError.otherError
                }
                
                if (500...599).contains(res.statusCode) {
                    print("🔴 NetworkError: serverError")
                    throw CommonError.serverError
                }
                
                #if DEBUG
                self?.logResponseInfo(res, data: data)
                #endif
                try responseHandler?(res)
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
