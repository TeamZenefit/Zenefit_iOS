//
//  URLSessionable.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/16.
//

import Foundation
import Combine

protocol URLSessionable {
    func dataTaskPublisher<T>(
        urlRequest: URLRequest,
        expect type: T.Type,
        responseHandler: ((_ response: HTTPURLResponse) throws -> Void)?)
    -> AnyPublisher<T, Error> where T: Decodable
}

extension URLSessionable {
    func logRequestInfo(_ request: URLRequest) {
        let body = String(data: request.httpBody ?? .init(),
                          encoding: .utf8)

        let log = """
            🔵 Network Request Info Log
                - absoluteURL: \(request.url?.absoluteString ?? "")
                - header: \(request.allHTTPHeaderFields ?? [:])
                - method: \(request.httpMethod ?? "")
                - body: \(body ?? "")
            """
        
        print(log)
    }
    
    func logResponseInfo(_ response: HTTPURLResponse, data: Data?) {
        let body = String(data: data ?? .init(),
                          encoding: .utf8)
        
        let log = """
            🔴 Network Response Info Log
                - absoluteURL: \(response.url?.absoluteString ?? "")
                - statusCode: \(response.statusCode)
                - data: \(body ?? "")
            """
        
        print(log)
    }
}

//class MockURLSession: URLSessionable {
//    func dataTaskPublisher(_ endPoint: EndpointProtocol) -> AnyPublisher<APIResponse, URLError> {
//        guard let urlRequest = endPoint.toURLRequest(),
//              let url = urlRequest.url else {
//            return Fail(error: URLError(.unsupportedURL))
//                .eraseToAnyPublisher()
//        }
//
//        guard let data = endPoint.sampleData else {
//            return Fail(error: URLError(.unknown))
//                .eraseToAnyPublisher()
//        }
//
//        let response = HTTPURLResponse(url: url,
//                                       statusCode: 200,
//                                       httpVersion: "2",
//                                       headerFields: nil)
//
//        return Just((data: data, response: response!))
//            .setFailureType(to: URLError.self)
//            .eraseToAnyPublisher()
//    }
//}
