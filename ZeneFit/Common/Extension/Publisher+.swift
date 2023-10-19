//
//  Publisher+.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/17.
//

import Foundation
import Combine

extension Publisher {
    var asyncThrows: Output {
        get async throws {
            try await withCheckedThrowingContinuation { continuation in
                var cancellable: AnyCancellable?
                var finishedWithoutValue = true
                cancellable = first()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            if finishedWithoutValue {
                                continuation.resume(throwing: AnyPublisherError.finishedWithoutValue)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    } receiveValue: { value in
                        finishedWithoutValue = false
                        continuation.resume(returning: value)
                    }
            }
        }
    }
    
    func asyncMap<T>(_ transform: @escaping (Output) async -> T) -> Publishers.FlatMap<Future<T, Failure>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}

enum AnyPublisherError: Error {
    case finishedWithoutValue
}
