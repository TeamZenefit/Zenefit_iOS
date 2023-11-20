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
    
    func getBookmarkPolicyList(page: Int) -> AnyPublisher<BookmarkPolicyListDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/policy",
                                queries: ["page" : "\(page)",
                                            "size" : "\(10)"])
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<BookmarkPolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> BookmarkPolicyListDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getBenefitPolicyList(page: Int) -> AnyPublisher<BenefitPolicyListDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/policy/apply",
                                queries: ["page" : "\(page)",
                                            "size" : "\(7)"])
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<BenefitPolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> BenefitPolicyListDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getWelfareMainInfo() -> AnyPublisher<WelfareMainInfoDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/policy/recommend")
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<WelfareMainInfoDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> WelfareMainInfoDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    //TODO: API수정 요청 필요
    func getPolicyInfo(page: Int,
                       supportPolicyType: SupportPolicyType,
                       policyType: PolicyType) -> AnyPublisher<PolicyListDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/policy",
                                queries: ["page" : "\(page)",
                                          "size" : "\(10)"])
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<PolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> PolicyListDTO in
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
