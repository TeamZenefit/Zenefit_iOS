//
//  NetworkService.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/02.
//

import Foundation
import Combine

final class NetworkService {
    // MARK: - Properties
    private let session: URLSession = .shared
    
    // MARK: - Methods
    
    func request(_ endpoint: EndpointProtocol) -> AnyPublisher<Data, Error> {
        guard let urlRequest = endpoint.toURLRequest() else {
            return Fail(error: CommonError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let res = response as? HTTPURLResponse else {
                    throw CommonError.otherError
                }
                
                guard (200...299).contains(res.statusCode) else {
                    throw CommonError.serverError
                }
                
                return data
            }
            .eraseToAnyPublisher()
    }
}
