//
//  PolicyService.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation
import Combine

class PolicyService {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func getRecommendWelfareList() -> AnyPublisher<RecommendWelFareDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/policy/recommend/count")
            .setAccessToken()
    
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<RecommendWelFareDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> RecommendWelFareDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
}
