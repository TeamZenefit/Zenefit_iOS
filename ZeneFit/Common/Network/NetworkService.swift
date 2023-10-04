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
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Methods
    func request<T>(_ endpoint: EndpointProtocol) -> AnyPublisher<T, Error> where T: Decodable {
        return session.dataTaskPublisher(endpoint)
            .tryMap { data, response -> Data in
                guard let res = response as? HTTPURLResponse else {
                    throw CommonError.otherError
                }
                
                guard (200...299).contains(res.statusCode) else {
                    throw CommonError.serverError
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

protocol URLSessionable {
    typealias APIResponse = URLSession.DataTaskPublisher.Output

    func dataTaskPublisher(_ endPoint: EndpointProtocol) -> AnyPublisher<APIResponse, URLError>
}

extension URLSession: URLSessionable {
    func dataTaskPublisher(_ endPoint: EndpointProtocol) -> AnyPublisher<APIResponse, URLError> {
        guard let urlRequest = endPoint.toURLRequest()
        else {
            return Fail(error: URLError(.unsupportedURL))
                .eraseToAnyPublisher()
        }
        
        return dataTaskPublisher(for: urlRequest).eraseToAnyPublisher()
    }
}


class MockURLSession: URLSessionable {
    func dataTaskPublisher(_ endPoint: EndpointProtocol) -> AnyPublisher<APIResponse, URLError> {
        guard let urlRequest = endPoint.toURLRequest(),
              let url = urlRequest.url else {
            return Fail(error: URLError(.unsupportedURL))
                .eraseToAnyPublisher()
        }
        
        guard let data = endPoint.sampleData else {
            return Fail(error: URLError(.unknown))
                .eraseToAnyPublisher()
        }

        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: "2",
                                       headerFields: nil)
        
        return Just((data: data, response: response!))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
